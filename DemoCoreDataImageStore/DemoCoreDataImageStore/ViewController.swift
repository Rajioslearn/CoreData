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
    
    
    var imageExists: Photo? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let fetchImage = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        
        do {
            guard let fetchedImage = try managedObjectContext.fetch(fetchImage) as? [Photo] else {
                return nil
            }
            
            if let imageData = fetchedImage.first?.image {
                
                let image = UIImage(data: imageData)
                imageView.image = image
                
                return fetchedImage.first
            }
            
        } catch {
            print("Error in fetching")
            return nil
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imagePickerController.modalPresentationStyle = .currentContext
        imagePickerController.delegate = self
        
       _ = imageExists
    }
    
    func fetchImage() -> Photo? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let fetchImage = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        
        do {
            guard let fetchedImage = try managedObjectContext.fetch(fetchImage) as? [Photo] else {
                return nil
            }
            
            if let imageData = fetchedImage.first?.image {
                
                let image = UIImage(data: imageData)
                imageView.image = image
                
                return fetchedImage.first
            }
            
        } catch {
            print("Error in fetching")
            return nil
        }
        return nil
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
        let data: Data?
        var photo: Photo?
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        
        guard let todoEntity = NSEntityDescription.entity(forEntityName: "Photo", in: managedObjectContext) else {
            return
        }
        
        if let fetchedPhoto = imageExists {
            photo = fetchedPhoto
        } else {
            photo = NSManagedObject(entity: todoEntity, insertInto: managedObjectContext) as? Photo
            
        }
        
        data = image.pngData()
        photo?.setValue(data, forKey: "image")
        
        if let imageData = photo?.image {
            let image = UIImage(data: imageData)
            imageView.image = image
        }
        
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
