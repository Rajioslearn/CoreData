//
//  ViewController.swift
//  Demo_Todo_list
//
//  Created by Rajeshnath Chyarngayil Vishwanath on 10/18/18.
//  Copyright © 2018 Rajeshnath Chyarngayil Vishwanath. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        
        guard let todoEntity = NSEntityDescription.entity(forEntityName: "Todo", in: managedObjectContext) else {
            return
        }
        
        let todo = NSManagedObject(entity: todoEntity, insertInto: managedObjectContext)
        
        todo.setValue("Service the car", forKey: "notes")
        
        // saving the data
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Could not save error")
        }
        
        // fetching the data
        
        let fetchNotes = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        
        do {
            guard let notes = try managedObjectContext.fetch(fetchNotes) as? [Todo] else {
                return
            }
            for note in notes {
                print(note.notes)
                
            }
            
        } catch {
            print("Error in fetching")
        }
    }

}

