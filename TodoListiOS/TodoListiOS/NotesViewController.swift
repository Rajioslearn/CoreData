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
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var isNotesinEditMode: Bool = false
    var note: Todo?
    
    @IBOutlet weak var noteText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        noteText.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadPreviousData()
    }
    
    func loadPreviousData() {
        if isNotesinEditMode {
            if let note = note {
                noteText.text = note.notes
            }
        }
    }

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        todo = nil
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        checkIfNotInEditingMode()
        saveNote()
        dismiss(animated: true, completion: nil)
    }
    
    func checkIfNotInEditingMode() {
        if !isNotesinEditMode {
            guard let managedObjectContext = managedObjectContext else {
                return
            }
            
            guard let todoEntity = NSEntityDescription.entity(forEntityName: "Todo", in: managedObjectContext) else {
                return
            }
            todo = NSManagedObject(entity: todoEntity, insertInto: managedObjectContext)
        }
    }
    
    func saveNote() {
        if isNotesinEditMode {
            note?.notes = noteText.text
        } else {
            todo?.setValue(noteText.text, forKey: "notes")
        }
        
        do {
            try managedObjectContext?.save()
        } catch {
            print("Could not save error")
        }
    }

}


extension NotesViewController: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 0 {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}
