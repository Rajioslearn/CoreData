//
//  ViewController.swift
//  DemoCoreDataRelationships
//
//  Created by Rajeshnath Chyarngayil Vishwanath on 10/25/18.
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
        
        //Create Person
        guard let entityPerson = NSEntityDescription.entity(forEntityName: "Person", in: managedObjectContext) else {
            return
        }
        
        let newPerson = NSManagedObject(entity: entityPerson, insertInto: managedObjectContext)
        // Populate Person
        newPerson.setValue("John", forKey: "first")
        newPerson.setValue("Jacobs", forKey: "last")
        newPerson.setValue(44, forKey: "age")
        
        // Create Address
        guard let entityAddress = NSEntityDescription.entity(forEntityName: "Address", in: managedObjectContext) else {
            return
        }
        
        let newAddress = NSManagedObject(entity: entityAddress, insertInto: managedObjectContext)
        
        // Populate Address
        
        newAddress.setValue("Main Street", forKey: "street")
        newAddress.setValue("Boston", forKey: "city")
        
        // Add Address to Person
        
        newPerson.setValue(NSSet(object: newAddress), forKey: "addresses")
        
        
        
        // showing one to one relations ships
        
        let anotherPerson = NSManagedObject(entity: entityPerson, insertInto: managedObjectContext)
        // Populate Person
        anotherPerson.setValue("Jane", forKey: "first")
        anotherPerson.setValue("Doe", forKey: "last")
        anotherPerson.setValue(44, forKey: "age")
        
        newPerson.setValue(anotherPerson, forKey: "spouse")
        
        
        // one to many relation ships
        
        let newChildPerson = NSManagedObject(entity: entityPerson, insertInto: managedObjectContext)
        // Populate Person
        newChildPerson.setValue("Jim", forKey: "first")
        newChildPerson.setValue("Doe", forKey: "last")
        newChildPerson.setValue(21, forKey: "age")
        
        // Create Relationship
        let children = newPerson.mutableSetValue(forKey: "children")
        children.add(newChildPerson)
        
        
        do {
            try newPerson.managedObjectContext?.save()
        } catch {
            print("Error in saving address in person model")
        }
        
        /* uncomment to show many to many relationships
        print(newPerson.value(forKey:"addresses")!)
        
        let addresses = newPerson.value(forKey:"addresses") as? Address
        // getting the person object from address
        print(addresses!.value(forKey: "persons")!) */

       /* uncomment to show many to many relationships
        print(newChildPerson.value(forKey: "father")!) */
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        
        // Add Sort Descriptor
        let sortDescriptor = NSSortDescriptor(key: "first", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Execute Fetch Request
        do {
            let result = try managedObjectContext.fetch(fetchRequest) as? [Person]
            
            for person in result! {
                if let first = person.value(forKey: "first"), let last = person.value(forKey: "last") {
                    print("\(first) \(last)")
                }
            }
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }


}

