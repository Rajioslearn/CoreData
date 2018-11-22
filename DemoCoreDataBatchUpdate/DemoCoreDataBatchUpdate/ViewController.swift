//
//  ViewController.swift
//  DemoCoreDataBatchUpdate
//
//  Created by Rajeshnath Chyarngayil Vishwanath on 11/22/18.
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
        
        
        guard let mailEntity = NSEntityDescription.entity(forEntityName: "Mail", in: managedObjectContext) else {
            return
        }
        
        // for e.g. there are lot of mails which is marked as unread
        
        for _ in 0..<1000000 {
            let mail = NSManagedObject(entity: mailEntity, insertInto: managedObjectContext)
            
            mail.setValue(false, forKey: "markAsRead")
        }
        
        
        // saving the data
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Could not save error")
        }
    }

    @IBAction func classicUpdate(_ sender: UIButton) {
        classicUpdate()
    }
    
    func classicUpdate() {
        
        let start = Date() // <<<<<<<<<< Start time
  
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        // Create a fetch request for the entity Person
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>() // 1
        let entityName = NSEntityDescription.entity(forEntityName: "Mail", in: managedObjectContext) // 2
        fetchRequest.entity = entityName // 3
        
        // Execute the fetch request
        
        do {
            guard let mails = try managedObjectContext.fetch(fetchRequest) as? [Mail] else {
                return
            }
            // Change the attributer name of
            // each managed object to the true
            for mail in mails {
                mail.markAsRead = true
            }
            
        } catch {
            print("Could not save error")
        }
        
        do {
            try managedObjectContext.save()
            let end = Date() // <<<<<<<<<< end time
            calculateTheTimeSpent(start, end)
            
        } catch {
            print("Could not save error")
        }
    }
    
    func calculateTheTimeSpent( _ start: Date, _ end: Date) {
        print(end.timeIntervalSince(start as Date))
    }
    
    @IBAction func batchUpdate(_ sender: UIButton) {
        batchUpdate()
    }
    
    func batchUpdate() {
        
        let start = Date() // <<<<<<<<<< Start time
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let batchRequest = NSBatchUpdateRequest(entityName: "Mail") // 2
        batchRequest.propertiesToUpdate = [ "markAsRead" : true ] // 3
        batchRequest.resultType = .updatedObjectsCountResultType // 4
        
        do {
            
            guard let mails =  try managedObjectContext.execute(batchRequest) as? NSBatchUpdateResult else {
                return
            }
            
            print("Updated objects \(mails.result ?? 0)")
            
            let end = Date() // <<<<<<<<<< end time
            calculateTheTimeSpent(start, end)
            
        } catch {
            print("errror in fetching")
        }
    }
}

