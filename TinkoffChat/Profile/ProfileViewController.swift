//
//  ProfileViewController2.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 30.03.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    
    @IBOutlet var editButton: UIBarButtonItem!
    
    let storageManager = StorageManager()
    
    var isEdittingMode = false
    
    var profileImage: UIImage? {
        get {
            if let data = appUser.user!.photo {
                return  UIImage(data: data)
            } else {
                return nil
            }
        }
        set {
            if let photo = newValue {
                appUser.user!.photo = UIImageJPEGRepresentation(photo, 1)
            } else {
                 appUser.user!.photo = nil
            }
        }
    }
    
    var profileImageData: Data? {
        get {
            return appUser.user!.photo
        }
    }
    
    lazy var appUser: TCAppUser = {
        return TCAppUser.findOrInsertAppUser(in: storageManager.mainContext)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func edit(_ sender: Any) { 
        func end(title: String){
            self.editButton.title = title
            self.isEdittingMode = !self.isEdittingMode
            let index = IndexSet(integer: 0)
            self.tableView.reloadSections(index, with: .automatic)
            
        }
        isEdittingMode ?
            save(completion: {end(title: "Ред.")}) :
            end(title: "Сохранить")
    }
    
    func save(completion: (() -> Void)?){
        let index2 = IndexPath(row: 2, section: 0)
        let cellName = self.tableView.cellForRow(at: index2) as! ProfileEdittingNameCell
        let index4 = IndexPath(row: 4, section: 0)
        let cellDesc = self.tableView.cellForRow(at: index4) as! ProfileEdittingDescriptionCell
        storageManager.mainContext.perform {
            self.appUser.user?.fullName = cellName.profileName.text
            self.appUser.user?.info = cellDesc.profileDescription.text
            self.appUser.user?.photo = self.profileImageData
            self.storageManager.performSave(context: self.storageManager.mainContext, completion: nil)
            completion?()
        }
    }
    
    @IBAction func changeProfileImage(_ sender: Any) {
        print("Выберите изображение профиля")
        let alertController = UIAlertController()
        let select = UIAlertAction(title: "Установить из галереи", style: .default){ _ in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .photoLibrary
                imagePickerController.allowsEditing = false
                imagePickerController.delegate = self
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
        alertController.addAction(select)
        let shot = UIAlertAction(title: "Сделать фото", style: .default){ _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .camera
                imagePickerController.allowsEditing = false
                imagePickerController.delegate = self
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
        
        alertController.addAction(shot)
        if profileImage != nil{
            let destroy = UIAlertAction(title: "Удалить фотографию", style: .destructive){ _ in
                // ВНИМАНИЕ! profileImage – вычисляемое свойство класса
                self.profileImage = nil
                let index = IndexPath(row: 0, section: 0)
                self.tableView.reloadRows(at: [index], with: .none)
            }
            alertController.addAction(destroy)
        }
        let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // ВНИМАНИЕ! profileImage – вычисляемое свойство класса
            self.profileImage = pickedImage
            //profileImage = pickedImage
            let index = IndexPath(row: 0, section: 0)
            tableView.reloadRows(at: [index], with: .none)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func close(_ sender: Any) {
        storageManager.mainContext.perform {
            self.storageManager.mainContext.refresh(self.appUser, mergeChanges: true)
        }
        dismiss(animated: true, completion: nil)
    }
    
}
