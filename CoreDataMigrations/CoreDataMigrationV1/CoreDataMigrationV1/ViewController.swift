//
//  ViewController.swift
//  CoreDataMigrationV1
//
//  Created by Rajeshnath Chyarngayil Vishwanath on 11/20/18.
//  Copyright © 2018 Rajeshnath Chyarngayil Vishwanath. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)
        print("\(path)")
        // Do any additional setup after loading the view, typically from a nib.
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        
        guard let personEntity = NSEntityDescription.entity(forEntityName: "PersonInfo", in: managedObjectContext) else {
            return
        }
        
        let person = NSManagedObject(entity: personEntity, insertInto: managedObjectContext)
        
        person.setValue("arunl", forKey: "name")
        person.setValue(2008, forKey: "ssn")
        person.setValue("sking", forKey: "hobby")
        
        // saving the data
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Could not save error")
        }
        
        // fetching the data
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PersonInfo")
        
        do {
            guard let persons = try managedObjectContext.fetch(fetchRequest) as? [PersonInfo] else {
                return
            }
            for person in persons {
                print(person.name)
                print(person.ssn)
                print(person.hobby)
                
            }
            
        } catch {
            print("Error in fetching")
        }
    }


}

