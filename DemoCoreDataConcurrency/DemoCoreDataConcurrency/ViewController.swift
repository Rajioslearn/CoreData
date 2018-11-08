//
//  ViewController.swift
//  DemoCoreDataConcurrency
//
//  Created by Rajeshnath Chyarngayil Vishwanath on 11/8/18.
//  Copyright © 2018 Rajeshnath Chyarngayil Vishwanath. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var displayLabel: UILabel!
    
    @IBOutlet weak var fetchedLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var fetchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func start(_ sender: UIButton) {
        startCounter()
    }
    
    func startCounter() {
        
        self.startAndFetchButton(isEnabled: false)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        guard let todoEntity = NSEntityDescription.entity(forEntityName: "Token", in: managedObjectContext) else {
            return
        }
        
        let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateMOC.parent = managedObjectContext
        
        privateMOC.perform {
            
            for i in 0...100000 {
                let todo = NSManagedObject(entity: todoEntity, insertInto: privateMOC)
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                    self.displayLabel.text = String(i)
                })
                todo.setValue(i, forKey: "count")
            }
            
            do {
                try privateMOC.save()
                managedObjectContext.perform {
                    do {
                        try managedObjectContext.save()
                        self.startAndFetchButton(isEnabled: true)
                        
                    } catch {
                        fatalError("Failure to save context: \(error)")
                    }
                }
            } catch {
                fatalError("Failure to save context: \(error)")
            }
            
        }
    }
    
    @IBAction func fetch(_ sender: UIButton) {
        fetchTokens()
    }
    @IBAction func green(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.changeLabelColorTo(color: .green)
        }
    }
    
    @IBAction func red(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.changeLabelColorTo(color: .red)
        }
    }
    
    @IBAction func blue(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.changeLabelColorTo(color: .blue)
        }
    }
    func fetchTokens() {
        
        DispatchQueue.main.async  {
            self.startAndFetchButton(isEnabled: false)
            
        }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let privateManagedObjectContext = appDelegate.persistentContainer.newBackgroundContext()
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Token")
        
        // Creates `asynchronousFetchRequest` with the fetch request and the completion closure
        let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { asynchronousFetchResult in
            
            // Retrieves an array of dogs from the fetch result `finalResult`
            guard let result = asynchronousFetchResult.finalResult as? [Token] else { return }

            // Dispatches to use the data in the main queue
            
            for value in result {
                DispatchQueue.main.async {
                    self.fetchedLabel.text = String(value.count)
                }
            }
            
            DispatchQueue.main.async  {
                self.startAndFetchButton(isEnabled: true)
            }
            
        }
        
        do {
            // Executes `asynchronousFetchRequest`
            try privateManagedObjectContext.execute(asynchronousFetchRequest)
        } catch let error {
            print("NSAsynchronousFetchRequest error: \(error)")
        }
        
    }
    
    func startAndFetchButton(isEnabled enabled: Bool) {
        self.fetchButton.isEnabled = enabled
        self.startButton.isEnabled = enabled
    }
    
    func changeLabelColorTo(color: UIColor) {
        self.displayLabel.backgroundColor = color
        self.fetchedLabel.backgroundColor = color
    }
    
    
}
