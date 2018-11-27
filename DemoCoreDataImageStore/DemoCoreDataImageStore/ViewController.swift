//
//  ViewController.swift
//  DemoCoreDataImageStore
//
//  Created by Rajeshnath Chyarngayil Vishwanath on 11/27/18.
//  Copyright © 2018 Rajeshnath Chyarngayil Vishwanath. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imagePickerController.modalPresentationStyle = .currentContext
        imagePickerController.delegate = self
        
        fetchImage()
    }
    
    func fetchImage() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let fetchImage = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        
        do {
            guard let fetchedImage = try managedObjectContext.fetch(fetchImage) as? [Photo] else {
                return
            }
            
            if let imageData = fetchedImage.first?.image {
                
                let image = UIImage(data: imageData)
                imageView.image = image
            }
            
        } catch {
            print("Error in fetching")
        }
    }

    @IBAction func pickImage(_ sender: Any) {
        openGallery()
    }
    
    func openGallery() {
        imagePickerController.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func save(image: UIImage) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        
        guard let todoEntity = NSEntityDescription.entity(forEntityName: "Photo", in: managedObjectContext) else {
            return
        }
        
        let todo = NSManagedObject(entity: todoEntity, insertInto: managedObjectContext)
        
        let data = image.pngData()
        
        todo.setValue(data, forKey: "image")
        
        // saving the data
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Could not save error")
        }
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        imageView.image = image
        save(image: image)
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
