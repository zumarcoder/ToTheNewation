//
//  SavingAnnotationToDB.swift
//  ToTheNewation
//
//  Created by Akash Verma on 12/06/19.
//  Copyright © 2019 Akash Verma. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol SavingDataToDB
{
    //declaration
    func addData(name : String , longitude : Double , latitude : Double)
    func addimageInGallary(location : String , username : String , originalImage : String)
    func addEmployeeData(id : String , employeename : String , employeesalary : String , employeeage : String , profileimage : String)
}

extension SavingDataToDB
{
    // defination of addData and saves the data in Database
    func addData(name : String , longitude : Double , latitude : Double)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else
        {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Annotation", in: context)
        let annotations = NSManagedObject(entity: entity!, insertInto: context)
        annotations.setValue(name , forKey: "name")
        annotations.setValue(longitude , forKey: "longitude")
        annotations.setValue(latitude , forKey: "latitude")
        do
        {
            try context.save()
        }catch let error as NSError
        {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func addimageInGallary(location : String , username : String , originalImage : String )
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else
        {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "UserImageData", in: context)
        let urls = NSManagedObject(entity: entity!, insertInto: context)
        urls.setValue(originalImage, forKey: "originalImage")
        urls.setValue(location , forKey: "urlImage")
        urls.setValue(username, forKey: "userName")
        do
        {
            try context.save()
        }catch let error as NSError
        {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func addEmployeeData(id : String , employeename : String , employeesalary : String , employeeage : String , profileimage : String)
    {
        DispatchQueue.main.async{
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else
            {
                return
            }
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "EmployeeList", in: context)
            let urls = NSManagedObject(entity: entity!, insertInto: context)
            urls.setValue(id, forKey: "id")
            urls.setValue(employeename , forKey: "employee_name")
            urls.setValue(employeesalary, forKey: "employee_salary")
            urls.setValue(employeeage, forKey: "employee_age")
            urls.setValue(profileimage, forKey: "profile_image")
            do
            {
                try context.save()
            }catch let error as NSError
            {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func deleteingFromDb(name : AnyClass)
    {
        DispatchQueue.main.async {
            // create the delete request for the specified entity
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = name.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            // get reference to the persistent container
            let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
            // perform the delete
            do {
                try persistentContainer.viewContext.execute(deleteRequest)
            } catch let error as NSError {
                print(error)
            }
        }
    }
}

