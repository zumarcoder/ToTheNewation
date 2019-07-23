//
//  ViewController.swift
//  ToTheNewation
//
//  Created by Akash Verma on 19/04/19.
//  Copyright © 2019 Akash Verma. All rights reserved.
//

import UIKit
import CoreData
import Firebase

protocol Gettable {
    func getEmpId(_ empId: String , _ empName : String)
}


class EmployeeListViewController: UIViewController , UITextFieldDelegate , NSFetchedResultsControllerDelegate , SavingDataToDB {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar : UISearchBar!
    
    var arraydata = [EmployeeStruct]()
    var arraydataFromDB = [EmployeeStruct]()
    var isSearching = false
    var filteredData = [EmployeeStruct]()
    let searchController = UISearchController(searchResultsController: nil)
    
    fileprivate lazy var fetchedResultController1: NSFetchedResultsController<EmployeeList> =
    {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest = EmployeeList.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "employee_name", ascending: true)]
        let fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context!, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        try! fetchResultController.performFetch()
        return fetchResultController
    }()

    override func viewDidLoad() {
//        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        print(urls[urls.count-1] as URL)
        self.tabBarController?.tabBar.layer.masksToBounds = false
        self.tabBarController?.tabBar.layer.shadowColor = UIColor.black.cgColor
        self.tabBarController?.tabBar.layer.shadowOpacity = 0.6
        self.tabBarController?.tabBar.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.tabBarController?.tabBar.layer.shadowRadius = 8
        self.tableView.isHidden = true
        activityIndicator.roundTheView(corner: 4)
        super.viewDidLoad()
        let nib = UINib.init(nibName: "EmployeeListCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        let tap = UITapGestureRecognizer(target: self.tableView, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        getdatafromdb()
        getData()
        showSearchBar()
        Analytics.logEvent("employee_list_launched", parameters: nil)
    }
    
    func showSearchBar() {
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Search employee name"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
    }
    
    override func viewDidDisappear(_ animated: Bool) {
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    func getData()
    {
        DispatchQueue.main.async {
            let url = URL(string: "http://dummy.restapiexample.com/api/v1/employees")
            URLSession.shared.dataTask(with: url!) { ( data , response , error ) in
                do{
                    if error == nil
                    {
                        self.arraydata = try JSONDecoder().decode([EmployeeStruct].self, from: data!)
                        if self.arraydataFromDB.count == 0
                        {
                            DispatchQueue.main.sync {
                                self.tableView.isHidden = true
                                self.activityIndicator.startAnimating()
                            }
                            self.getdatafromAPI()
                        }

                            self.setdatatoDB()
                    }
                    else
                    {
                        self.getdatafromdb()
                    }
                }
                    
                catch
                {
                    print(error.localizedDescription)
                    let alert = UIAlertController(title: "Something Wrong Happened", message: error.localizedDescription , preferredStyle:.alert)
                    alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: {action in self.getData()}))
                    self.present(alert, animated: true, completion: nil)
                }
                }.resume()
        }
    }
    
    func setdatatoDB()
    {
//        print(self.fetchedResultController1.fetchedObjects!)
//        print(self.arraydata)
            if self.arraydata.count == self.arraydataFromDB.count
            {
                // do nothing
            }
            else
            {
                self.deleteingFromDb(name: EmployeeList.self)
                //self.deleteingFromDb(name : Annotation.self)
                //self.deleteingFromDb(name: UserImageData.self)
                for item in self.arraydata
                {
                    DispatchQueue.main.sync {
                        self.addEmployeeData(id : item.id , employeename : item.employee_name , employeesalary : item.employee_salary , employeeage : item.employee_age , profileimage : item.profile_image)
                    }
                }
            }
    }
    
    func getdatafromAPI()
    {
        DispatchQueue.main.async {
            self.arraydataFromDB = self.arraydata
            self.tableView.reloadData()
            self.tableView.isHidden = false
            self.activityIndicator.stopAnimating()
        }
    }
    
    func getdatafromdb()
    {
        DispatchQueue.main.async {
            for item in self.fetchedResultController1.fetchedObjects!
            {
                let tempStruct = EmployeeStruct(id: item.id! , employee_name: item.employee_name! , employee_salary: item.employee_salary!, employee_age: item.employee_age! , profile_image: item.profile_image! )
                self.arraydataFromDB.append(tempStruct)
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.isHidden = false
            self.activityIndicator.stopAnimating()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem?.title = "Employee List"
        if(self.searchController == nil)
        {
            showSearchBar()
        }
        else
        {
            self.definesPresentationContext = true
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tableView.deselectSelectedRow(animated: true)
        self.searchController.dismiss(animated: true, completion: nil)
    }
}

extension EmployeeListViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching
        {
            return filteredData.count
        }
        else
        {
            return arraydataFromDB.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EmployeeListCell
        if isSearching
        {
            cell.nameLabel.text = filteredData[indexPath.row].employee_name
        }
        else
        {
            cell.nameLabel.text = arraydataFromDB[indexPath.row].employee_name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching{
            let id = filteredData[indexPath.row].id
            let name = filteredData[indexPath.row].employee_name
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let controller = storyBoard.instantiateViewController(withIdentifier: "EmployeeDetails") as! EmployeeDetails
            var delegate: Gettable!
            delegate.self = controller
            delegate.getEmpId(id , name)
            self.navigationController?.pushViewController(controller, animated: true)
        }
        else
        {
            let id = arraydataFromDB[indexPath.row].id
            let name = arraydataFromDB[indexPath.row].employee_name
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let controller = storyBoard.instantiateViewController(withIdentifier: "EmployeeDetails") as! EmployeeDetails
            var delegate: Gettable!
            delegate.self = controller
            delegate.getEmpId(id , name)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
    func depthEffect (element : UIView , shadowColor : UIColor , shadowOpacity : Float  , shadowOffSet : CGSize , shadowRadius : Float)
    {
        element.layer.masksToBounds = false
        element.layer.shadowColor = UIColor.lightGray.cgColor
        element.layer.shadowOpacity = 0.6
        element.layer.shadowOffset = CGSize(width: 0, height: 1.6)
        element.layer.shadowRadius = 4
    }
}

// searchbar logic

extension EmployeeListViewController : UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData.removeAll()
        if(searchBar.text!.isEmpty)
        {
            isSearching = false
            tableView.reloadData()
        }
       else
        {
            isSearching = true
            for item in arraydataFromDB
            {
                if(item.employee_name.hasPrefix(searchBar.text!))
                {
                    filteredData.append(item)
                }
            }
            tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.isSearching = false
        self.tableView.reloadData()
    }
}
