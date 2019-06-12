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
        let recipeObject = NSManagedObject(entity: entity!, insertInto: context)
        recipeObject.setValue(name , forKey: "name")
        recipeObject.setValue(longitude , forKey: "longitude")
        recipeObject.setValue(latitude , forKey: "latitude")
        do
        {
            try context.save()
        }catch let error as NSError
        {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}

