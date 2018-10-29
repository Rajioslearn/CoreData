//
//  ViewController.swift
//  DemoPredicate
//
//  Created by Rajeshnath Chyarngayil Vishwanath on 10/29/18.
//  Copyright © 2018 Rajeshnath Chyarngayil Vishwanath. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, CoreDataClient {
    var managedObjectContext: NSManagedObjectContext?
    
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    
    @IBOutlet weak var contactNumberText: UITextField!
    @IBOutlet weak var emailIdText: UITextField!
    
    var allContacts: [Contact] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        fetchContacts()
    }
    
    
    func saveContacts() {
        guard let managedObjectContext = managedObjectContext else {
            return
        }
        guard let newContact = NSEntityDescription.insertNewObject(forEntityName: "Contact", into: managedObjectContext) as? Contact else {
            return
        }
        newContact.firstName = firstNameText.text
        newContact.lastName = lastNameText.text
        newContact.emailId = emailIdText.text
        newContact.contactNumber = Int64(contactNumberText.text!)!
        
        do {
            try managedObjectContext.save()
            print("saved user")
        } catch {
            print("error in saving context")
        }
        
    }

    func fetchContacts() {
        let fetchContactRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Contact")
        
        guard let managedObjectContext = managedObjectContext else {
            return
        }
        
        let predicate = NSPredicate(format: "lastName == %@", "jobs")
        fetchContactRequest.predicate = predicate
        
        do {
            guard let contacts = try managedObjectContext.fetch(fetchContactRequest) as? [Contact] else {
                return
            }
            
            for contact in contacts {
                print("\(contact.firstName) \((contact.lastName))")
            }
            
        } catch {
            print("Error in fetching rows")
        }
    }
    
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        saveContacts()
    }
    

}

