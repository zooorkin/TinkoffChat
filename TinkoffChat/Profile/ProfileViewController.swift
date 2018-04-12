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
            let index = IndexPath(row: 0, section: 0)
            if !isEdittingMode {
                let cell = self.tableView.cellForRow(at: index) as! ProfilePhotoCell
                return cell.profileImage
            } else {
                let cell = self.tableView.cellForRow(at: index) as! ProfileEdittingPhotoCell
                return cell.profileImage
            }
        }
        set {
            let index = IndexPath(row: 0, section: 0)
            if !isEdittingMode {
                let cell = self.tableView.cellForRow(at: index) as! ProfilePhotoCell
                cell.profileImage = newValue
            } else {
                let cell = self.tableView.cellForRow(at: index) as! ProfileEdittingPhotoCell
                cell.profileImage = newValue
            }
        }
    }
    
    lazy var appUser: AppUser = {
        return AppUser.findOrInsertAppUser(in: storageManager.mainContext)!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var editting = false
    
    @IBAction func edit(_ sender: Any) {
        if isEdittingMode {
            let index2 = IndexPath(row: 2, section: 0)
            let cellName = self.tableView.cellForRow(at: index2) as! ProfileEdittingNameCell
            let index4 = IndexPath(row: 4, section: 0)
            let cellDesc = self.tableView.cellForRow(at: index4) as! ProfileEdittingDescriptionCell
            storageManager.mainContext.perform {
                self.appUser.currentUser?.name = cellName.profileName.text
                self.appUser.currentUser?.info = cellDesc.profileDescription.text
                if let photo = self.profileImage {
                    self.appUser.currentUser?.photo = UIImagePNGRepresentation(photo)
                }else{
                    self.appUser.currentUser?.photo = nil
                }
                self.storageManager.performSave(context: self.storageManager.mainContext, completion: nil)
                self.editButton.title = "Ред."
                self.isEdittingMode = !self.isEdittingMode
                let index = IndexSet(integer: 0)
                self.tableView.reloadSections(index, with: .automatic)
            }
        } else {
            editButton.title = "Сохранить"
            isEdittingMode = !isEdittingMode
            let index = IndexSet(integer: 0)
            self.tableView.reloadSections(index, with: .automatic)
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
            
            profileImage = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isEdittingMode{
            return 5
        }else{
            return 3
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !isEdittingMode{
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfilePhotoCell", for: indexPath) as? ProfilePhotoCell
                if let image = appUser.currentUser?.photo {
                    cell!.profileImage = UIImage(data: image)
                } else {
                    cell!.profileImage = nil
                }
                return cell!
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileNameCell", for: indexPath) as? ProfileNameCell
                cell!.profileName.text = appUser.currentUser?.name ?? ""
                return cell!
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDescriptionCell", for: indexPath) as? ProfileDescriptionCell
                cell!.profileDescription.text = appUser.currentUser?.info
                return cell!
            default:
                fatalError()
            }
        }else{
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEdittingPhotoCell", for: indexPath) as? ProfileEdittingPhotoCell
                if let image = appUser.currentUser?.photo {
                    cell!.profileImage = UIImage(data: image)
                } else {
                    cell!.profileImage = nil
                }
                return cell!
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHeaderCell", for: indexPath) as? ProfileHeaderCell
                cell?.header = "Имя пользователя"
                return cell!
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEdittingNameCell", for: indexPath) as? ProfileEdittingNameCell
                cell!.profileName.text = appUser.currentUser?.name ?? ""
                return cell!
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileHeaderCell", for: indexPath) as? ProfileHeaderCell
                cell?.header = "Описание"
                return cell!
            case 4:
                let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileEdittingDescriptionCell", for: indexPath) as? ProfileEdittingDescriptionCell
                cell!.profileDescription.text = appUser.currentUser?.info
                return cell!
            default:
                fatalError()
            }
        }
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
