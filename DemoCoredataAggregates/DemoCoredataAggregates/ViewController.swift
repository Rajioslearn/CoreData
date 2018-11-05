//
//  ViewController.swift
//  DemoCoredataAggregates
//
//  Created by Rajeshnath Chyarngayil Vishwanath on 11/5/18.
//  Copyright © 2018 Rajeshnath Chyarngayil Vishwanath. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        //Create Employee
        guard let entityPerson = NSEntityDescription.entity(forEntityName: "EmployeeInfo", in: managedObjectContext) else {
            return
        }
        
        let employee1 = NSManagedObject(entity: entityPerson, insertInto: managedObjectContext)
        
        employee1.setValue(2001, forKey: "empId")
        employee1.setValue("suresh", forKey: "empName")
        employee1.setValue(30000, forKey: "salary")
        
        let employee2 = NSManagedObject(entity: entityPerson, insertInto: managedObjectContext)
        
        employee2.setValue(2002, forKey: "empId")
        employee2.setValue("Rajiv", forKey: "empName")
        employee2.setValue(35000, forKey: "salary")
        
        let employee3 = NSManagedObject(entity: entityPerson, insertInto: managedObjectContext)
        
        employee3.setValue(2003, forKey: "empId")
        employee3.setValue("ganesh", forKey: "empName")
        employee3.setValue(30000, forKey: "salary")
        
        let employee4 = NSManagedObject(entity: entityPerson, insertInto: managedObjectContext)
        
        employee4.setValue(2004, forKey: "empId")
        employee4.setValue("rijesh", forKey: "empName")
        employee4.setValue(36000, forKey: "salary")
        
        do {
            try employee1.managedObjectContext?.save()
            try employee2.managedObjectContext?.save()
            try employee3.managedObjectContext?.save()
            try employee4.managedObjectContext?.save()
        } catch {
            print("Error in saving address in person model")

        }

        /*
        // uncomment to demostrate count
        // shows how many employees are earning for e.g 35000 and how many 30000
        let keyPathExp = NSExpression(forKeyPath: "salary")
        let expression = NSExpression(forFunction: "count:", arguments: [keyPathExp])

        let countDesc = NSExpressionDescription()
        countDesc.expression = expression
        countDesc.name = "count"
        countDesc.expressionResultType = .integer64AttributeType

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "EmployeeInfo")
        request.returnsObjectsAsFaults = false
        request.propertiesToGroupBy = ["salary"]
        request.propertiesToFetch = ["salary", countDesc]
        request.resultType = .dictionaryResultType
        */
        
        /*
         // uncomment to demostrate sum
         // shows collective salary of all emplyees
         let keyPathExp = NSExpression(forKeyPath: "salary")
         let expression = NSExpression(forFunction: "sum:", arguments: [keyPathExp])
         
         let sumDesc = NSExpressionDescription()
         sumDesc.expression = expression
         sumDesc.name = "sum"
         sumDesc.expressionResultType = .integer64AttributeType
         
         let request = NSFetchRequest<NSFetchRequestResult>(entityName: "EmployeeInfo")
         request.returnsObjectsAsFaults = false
         request.propertiesToFetch = [sumDesc]
         request.resultType = .dictionaryResultType
        */
        
        /*
        // uncomment to demonstrate average
        // shows the average of salary
         let keyPathExp = NSExpression(forKeyPath: "salary")
         let expression = NSExpression(forFunction: "average:", arguments: [keyPathExp])
         
         let averageDesc = NSExpressionDescription()
         averageDesc.expression = expression
         averageDesc.name = "average"
         averageDesc.expressionResultType = .integer64AttributeType
         
         let request = NSFetchRequest<NSFetchRequestResult>(entityName: "EmployeeInfo")
         request.returnsObjectsAsFaults = false
         request.propertiesToFetch = [averageDesc]
         request.resultType = .dictionaryResultType
         */
        
        // uncomment to demonstrate max
        // shows max of salaray
        
        let keyPathExp = NSExpression(forKeyPath: "salary")
        let expression = NSExpression(forFunction: "max:", arguments: [keyPathExp])
        
        let maxDesc = NSExpressionDescription()
        maxDesc.expression = expression
        maxDesc.name = "max"
        maxDesc.expressionResultType = .integer64AttributeType
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "EmployeeInfo")
        request.returnsObjectsAsFaults = false
        request.propertiesToFetch = [maxDesc]
        request.resultType = .dictionaryResultType
        

        do {
            let result = try managedObjectContext.fetch(request)
            print(result)
        } catch {
            print("fetch error")
        }
        
    }
}
