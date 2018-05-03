//
//  TCProfileCells.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 07.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit

class TCProfilePhotoCell: UITableViewCell {
    
    public var profileImage: UIImage?{
        get{
            if let strongProfileImage = profilePhoto.image, strongProfileImage.isEqual(defaultProfileImage){
                return nil
            }
            return profilePhoto.image
        }
        set(newImage){
            if let strongNewImage = newImage{
                profilePhoto.contentMode = .scaleAspectFill
                profilePhoto.image = strongNewImage
            } else {
                profilePhoto.image = defaultProfileImage
                profilePhoto.contentMode = .scaleAspectFit
            }
        }
    }
    
    private let defaultProfileImage = UIImage(named: "placeholder-user")
    @IBOutlet private var profilePhoto: UIImageView!
}

class TCProfileEdittingPhotoCell: UITableViewCell, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    public weak var tableViewController: UITableViewController?
    public var model: ITCProfileModel?
    
    @IBOutlet private var profilePhoto: UIImageView!
    private let defaultProfileImage = UIImage(named: "placeholder-user")!
    
    var profileImage: UIImage?{
        get{
            if let strongProfileImage = profilePhoto.image, strongProfileImage.isEqual(defaultProfileImage){
                return nil
            }
            return profilePhoto.image
        }
        set(newImage){
            if let strongNewImage = newImage{
                profilePhoto.contentMode = .scaleAspectFill
                profilePhoto.image = strongNewImage
            } else {
                profilePhoto.image = defaultProfileImage
                profilePhoto.contentMode = .scaleAspectFit
            }
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
                self.tableViewController?.present(imagePickerController, animated: true, completion: nil)
            }
        }
        alertController.addAction(select)
        let shot = UIAlertAction(title: "Сделать фото", style: .default){ _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .camera
                imagePickerController.allowsEditing = false
                imagePickerController.delegate = self
                self.tableViewController?.present(imagePickerController, animated: true, completion: nil)
            }
        }
        
        alertController.addAction(shot)
        if profileImage != nil{
            let destroy = UIAlertAction(title: "Удалить фотографию", style: .destructive){ _ in
                // ВНИМАНИЕ! profileImage – вычисляемое свойство класса
                self.model?.setNew(photo: self.defaultProfileImage)
                self.model?.fetchUpdate()
                let index = IndexPath(row: 0, section: 0)
                self.tableViewController?.tableView.reloadRows(at: [index], with: .none)
            }
            alertController.addAction(destroy)
        }
        let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        tableViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // ВНИМАНИЕ! profileImage – вычисляемое свойство класса
            model?.setNew(photo: pickedImage)
            model?.fetchUpdate()
            let index = IndexPath(row: 0, section: 0)
            self.tableViewController?.tableView.reloadRows(at: [index], with: .none)
        }
        tableViewController?.dismiss(animated: true, completion: nil)
    }
}

class TCProfileNameCell: UITableViewCell {
    
    var name: String? {
        get {
            return profileName.text
        }
        set {
            profileName.text = newValue
        }
    }
    @IBOutlet private var profileName: UILabel!
}

class TCProfileEdittingNameCell: UITableViewCell, UITextViewDelegate {
    
    public var model: ITCProfileModel?
    
    var name: String {
        get {
            return profileName.text
        }
        set {
            profileName.text = newValue
        }
    }
    @IBOutlet private var profileName: EditTextView!
    
    func textViewDidChange(_ textView: UITextView) {
        model?.setNew(name: textView.text)
    }
}

class TCProfileDescriptionCell: UITableViewCell {
    
    var info: String? {
        get {
            return profileDescription.text
        }
        set {
            profileDescription.text = newValue
        }
    }
    @IBOutlet private var profileDescription: UILabel!
}

class TCProfileEdittingDescriptionCell: UITableViewCell, UITextViewDelegate {
    
    public var model: ITCProfileModel?
    var info: String {
        get {
            return profileDescription.text
        }
        set {
            profileDescription.text = newValue
        }
    }
    @IBOutlet private var profileDescription: EditTextView!
    
    func textViewDidChange(_ textView: UITextView) {
        model?.setNew(info: textView.text)
    }
}

class TCProfileHeaderCell: UITableViewCell {

    var header: String? {
        get {
            return headerLabel.text
        }
        set {
            headerLabel.text = newValue
        }
    }
    @IBOutlet private var headerLabel: UILabel!
}
