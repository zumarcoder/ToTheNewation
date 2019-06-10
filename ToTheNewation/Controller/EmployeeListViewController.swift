//
//  ViewController.swift
//  ToTheNewation
//
//  Created by Akash Verma on 19/04/19.
//  Copyright © 2019 Akash Verma. All rights reserved.
//

import UIKit

protocol Gettable {
    func getEmpId(_ empId: String)
}


class EmployeeListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var arraydata = [EmployeeStruct]()
    
    override func viewDidLoad() {
        self.depthEffect(element: self.navigationController!.navigationBar, shadowColor: UIColor.lightGray, shadowOpacity: 0.6, shadowOffSet: CGSize(width: 0, height: 1.6), shadowRadius: 4)
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
        getData()
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

                print("Error in getData()")
            }
            }.resume()
    }
    
    override func viewWillAppear(_ animated: Bool) {
      self.navigationController?.navigationBar.topItem?.title = "Employee List"
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.tableView.deselectSelectedRow(animated: true)
    }
}

extension EmployeeListViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arraydata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EmployeeListCell
        cell.nameLabel.text = arraydata[indexPath.row].employee_name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = arraydata[indexPath.row].id
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: "EmployeeDetails") as! EmployeeDetails
        var delegate: Gettable!
        delegate.self = controller
        delegate.getEmpId(id)
        self.navigationController?.pushViewController(controller, animated: true)
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
