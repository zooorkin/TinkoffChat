//
//  TCProfileViewController.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 29.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit
import CoreData

class TCProfileViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
   
    var editButton: UIBarButtonItem!
    var isEdittingMode = false
    
    private let presentationAssembly: ITCPresentationAssembly
    private var manager: ITCManager
    
    var mainContext: NSManagedObjectContext {
        return presentationAssembly.servicesAssembly.coreAssembly.coreDataStack.mainContext
    }
    
    init(presentationAssembly: ITCPresentationAssembly, manager: ITCManager) {
        self.presentationAssembly = presentationAssembly
        self.manager = manager
        super.init(nibName: TCNibName.TCProfile.rawValue, bundle: nil)
        print("----TCProfileViewController has been initialized")
        print("------Now TCConversationListViewController is delegate of TCManager")
    }
    
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
        return TCAppUser.findOrInsertAppUser(in: mainContext)
    }()
    
    
    // MARK: - init
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func registerNibs() {
        let nib1 = UINib(nibName: TCNibName.TCProfilePhotoCell.rawValue, bundle: nil)
        let nib2 = UINib(nibName: TCNibName.TCProfileNameCell.rawValue, bundle: nil)
        let nib3 = UINib(nibName: TCNibName.TCProfileDescriptionCell.rawValue, bundle: nil)
        let nib4 = UINib(nibName: TCNibName.TCProfileHeaderCell.rawValue, bundle: nil)
        let nib5 = UINib(nibName: TCNibName.TCProfileEdittingPhotoCell.rawValue, bundle: nil)
        let nib6 = UINib(nibName: TCNibName.TCProfileEdittingNameCell.rawValue, bundle: nil)
        let nib7 = UINib(nibName: TCNibName.TCProfileEdittingDescriptionCell.rawValue, bundle: nil)
        tableView.register(nib1, forCellReuseIdentifier: TCNibName.TCProfilePhotoCell.rawValue)
        tableView.register(nib2, forCellReuseIdentifier: TCNibName.TCProfileNameCell.rawValue)
        tableView.register(nib3, forCellReuseIdentifier: TCNibName.TCProfileDescriptionCell.rawValue)
        tableView.register(nib4, forCellReuseIdentifier: TCNibName.TCProfileHeaderCell.rawValue)
        
        tableView.register(nib5, forCellReuseIdentifier: TCNibName.TCProfileEdittingPhotoCell.rawValue)
        tableView.register(nib6, forCellReuseIdentifier: TCNibName.TCProfileEdittingNameCell.rawValue)
        tableView.register(nib7, forCellReuseIdentifier: TCNibName.TCProfileEdittingDescriptionCell.rawValue)
    }
    
    override func viewDidLoad() {
        adjustNavigationBar()
        super.viewDidLoad()
        registerNibs()
    }
    
    // MARK: -
    
    private func adjustNavigationBar(){
        title = "Мой профиль"
        navigationController?.navigationBar.tintColor = UIColor.black
        if let topItem = navigationController?.navigationBar.topItem {
            let leftButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(close))
            let rightButton = UIBarButtonItem(title: "Ред.", style: .plain, target: self, action: #selector(edit(_:)))
            editButton = rightButton
            topItem.leftBarButtonItem = leftButton
            topItem.rightBarButtonItem = rightButton
        } else {
            fatalError()
        }
    }
    
    @objc func edit(_ sender: Any) {
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
        let cellName = self.tableView.cellForRow(at: index2) as! TCProfileEdittingNameCell
        let index4 = IndexPath(row: 4, section: 0)
        let cellDesc = self.tableView.cellForRow(at: index4) as! TCProfileEdittingDescriptionCell
        mainContext.perform {
            self.appUser.user?.fullName = cellName.profileName.text
            self.appUser.user?.info = cellDesc.profileDescription.text
            self.appUser.user?.photo = self.profileImageData
            self.presentationAssembly.servicesAssembly.coreAssembly.coreDataStack.performSave(context: self.mainContext, completion: nil)
            completion?()
        }
    }
    
    @objc private func close() {
        dismiss(animated: true, completion: nil)
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

}
