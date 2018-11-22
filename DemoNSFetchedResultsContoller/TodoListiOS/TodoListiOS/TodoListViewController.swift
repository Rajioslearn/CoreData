//
//  todoListViewController.swift
//  TodoListiOS
//
//  Created by Rajeshnath Chyarngayil Vishwanath on 10/18/18.
//  Copyright © 2018 Rajeshnath Chyarngayil Vishwanath. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController, CoreDataClient, NSFetchedResultsControllerDelegate {
    var managedObjectContext: NSManagedObjectContext?
    
    // code related to NSFetchresults contoller
    var fetchResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    
    var todoList: [Todo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchNotes()
    }
    
    
    // Mark: - Fetches the notes from Todo entity
    func fetchNotes() {
        let fetchNotes = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        
        guard let managedObjectContext = managedObjectContext else {
            return
        }
        
        // implementing NSFetchResultsController
        
        let fetchSort = NSSortDescriptor(key: "notes", ascending: true)
        fetchNotes.sortDescriptors = [fetchSort]
        
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchNotes, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultsController?.delegate = self
        
        do {
            try fetchResultsController?.performFetch()
            tableView.reloadData()
        } catch(let error) {
            print("Unable to perform fetch: \(error.localizedDescription)")
        }
        
        
        
        // commenting old code
        
        /*
        do {
            guard let notes = try managedObjectContext.fetch(fetchNotes) as? [Todo] else {
                return
            }
            
            todoList = notes
            tableView.reloadData()
        } catch {
            print("Error in fetching rows")
        } */
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
       
        guard let fetchResultsController = fetchResultsController else {
            return 0
        }
        guard let sectionCount = fetchResultsController.sections?.count else {
            return 0
        }
        return sectionCount
        
        // commenting olde code
        /*
        return 1 */
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        // implmenting NSFectchResultsController
        
        guard let fetchResultsController = fetchResultsController else {
            return 0
        }
        
        guard let sectionData = fetchResultsController.sections?[section] else {
            return 0
        }
        return sectionData.numberOfObjects
        
        // commenting olde code
       /* return todoList.count */
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Configure the cell...
        // implementing NSFetchResultsController
        
        let note = fetchResultsController?.object(at: indexPath) as! Todo
        cell.textLabel?.text = note.value(forKey: "notes") as? String
        // commenting old code
        /*cell.textLabel?.text = todoList[indexPath.row].notes */
        return cell
    }
    
    // MARK: - FetchedResultsController Delegate
    
    
    
    private func controllerDidChangeContent(controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
    
    @IBAction func addNotes(_ sender: UIBarButtonItem) {
        presentNotesViewContollerFor(selectedRow: nil, openInEditingMode: false)
    }
    
    func presentNotesViewContollerFor(selectedRow: IndexPath? /*Int?*/, openInEditingMode editing: Bool) {
        if let notesViewController = storyboard?.instantiateViewController(withIdentifier: "notes") as? NotesViewController {
            notesViewController.managedObjectContext = managedObjectContext
            notesViewController.isNotesinEditMode = editing
            
            if editing {
                if let selectedRow = selectedRow {
                    
                    let note = fetchResultsController?.object(at: selectedRow) as! Todo
                    notesViewController.note = note
                    /*
                     notesViewController.note = todoList[selectedRow]
                     */
                }
            }
            
            let navigationController = UINavigationController(rootViewController: notesViewController)
            present(navigationController, animated: true, completion: nil)
        }
    }
 
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       
        if editingStyle == .delete  {
            let note = fetchResultsController?.object(at: indexPath) as! Todo
            managedObjectContext?.delete(note)
        }
        
        do {
            try managedObjectContext?.save()
        } catch {
            print("Error in saving after deletingthe context")
        }
        
        // commenting old code
        /*
        if editingStyle == .delete {
            // Delete the row from the data source
            
            let note = todoList[indexPath.row]
            managedObjectContext?.delete(note)
            todoList.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            do {
                try managedObjectContext?.save()
            } catch {
                print("Error in saving after deletingthe context")
            }
        }*/
    }
    
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentNotesViewContollerFor(selectedRow: indexPath, openInEditingMode: true)
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
