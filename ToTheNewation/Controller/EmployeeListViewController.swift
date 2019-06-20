//
//  ViewController.swift
//  ToTheNewation
//
//  Created by Akash Verma on 19/04/19.
//  Copyright © 2019 Akash Verma. All rights reserved.
//

import UIKit

protocol Gettable {
    func getEmpId(_ empId: String , _ empName : String)
}


class EmployeeListViewController: UIViewController , UITextFieldDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar : UISearchBar!
    
    var arraydata = [EmployeeStruct]()
    var isSearching = false
    var filteredData = [EmployeeStruct]()
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
//        self.depthEffect(element: self.navigationController!.navigationBar, shadowColor: UIColor.lightGray, shadowOpacity: 0.6, shadowOffSet: CGSize(width: 0, height: 1.6), shadowRadius: 4)
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
        getData()
        showSearchBar()
    }
    
    
    func showSearchBar() {
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.placeholder = "Search employee name or ID"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        AppDelegate.AppUtility.lockOrientation(.portrait)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    
    
    func getData()
    {
        let url = URL(string: "http://dummy.restapiexample.com/api/v1/employees")
        URLSession.shared.dataTask(with: url!) { ( data , response , error ) in
            do{
                if error == nil
                {
                    self.arraydata = try JSONDecoder().decode([EmployeeStruct].self, from: data!)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.tableView.isHidden = false
                        self.activityIndicator.stopAnimating()
                    }
                }
                else
                {
                    let alert = UIAlertController(title: "Something Wrong Happened", message: "Tap retry to try again", preferredStyle:.alert)
                    alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: {action in self.getData()}))
                    self.present(alert, animated: true, completion: nil)
                }
            }
                
            catch
            {
                
                print(error.localizedDescription)
            }
            }.resume()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppDelegate.AppUtility.lockOrientation(.all)
        self.navigationController?.navigationBar.topItem?.title = "Employee List"
        if(self.searchController == nil)
        {
            showSearchBar()
        }else{
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
            return arraydata.count
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
            cell.nameLabel.text = arraydata[indexPath.row].employee_name
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
            let id = arraydata[indexPath.row].id
            let name = arraydata[indexPath.row].employee_name
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
            for item in arraydata
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
    }}
