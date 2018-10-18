//
//  NotesViewController.swift
//  TodoListiOS
//
//  Created by Rajeshnath Chyarngayil Vishwanath on 10/18/18.
//  Copyright © 2018 Rajeshnath Chyarngayil Vishwanath. All rights reserved.
//

import UIKit
import CoreData

class NotesViewController: UIViewController, CoreDataClient {
    var managedObjectContext: NSManagedObjectContext?
    
    private var todo: NSManagedObject?
    
    @IBOutlet weak var noteText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpEntity()
    }
    
    func setUpEntity() {
        guard let managedObjectContext = managedObjectContext else {
            return
        }
        
        guard let todoEntity = NSEntityDescription.entity(forEntityName: "Todo", in: managedObjectContext) else {
            return
        }
        todo = NSManagedObject(entity: todoEntity, insertInto: managedObjectContext)
    }

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        todo?.setValue(noteText.text, forKey: "notes")
        
        do {
            try managedObjectContext?.save()
        } catch {
            print("Could not save error")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
