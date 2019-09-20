//
//  TCProfileViewController.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 29.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit
import CoreData

class TCProfileViewController: UITableViewController, ITCProfileModelDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ITCInternetImagesDelegate {
    
    func setNew(photo: UIImage) {
        model.setNew(photo: photo)
        model.fetchUpdate()
        let index = IndexPath(row: 0, section: 0)
        self.tableView.reloadRows(at: [index], with: .none)
    }
    
    func update(dataSource: [TCProfileCellModel]) {
        self.dataSource = dataSource
    }
    
    var editButton: UIBarButtonItem!
    
    private let presentationAssembly: ITCPresentationAssembly
    
    public var model: ITCProfileModel
    
    internal var dataSource: [TCProfileCellModel] = []
    
    init(presentationAssembly: ITCPresentationAssembly, model: ITCProfileModel) {
        self.presentationAssembly = presentationAssembly
        self.model = model
        super.init(nibName: TCNibName.TCProfile.rawValue, bundle: nil)
    }
    
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
        model.fetchUpdate()
        registerNibs()
    }
    
    // MARK: -
    
    func changeProfileImage(withDelete: Bool) {
        
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
        
        let internetImages = UIAlertAction(title: "Загрузить", style: .default){ _ in
            let internetImagesViewController = self.presentationAssembly.internetImagesViewController()
            internetImagesViewController.delegate = self
            let navigationController = self.presentationAssembly.navigationController(rootViewController: internetImagesViewController)
            self.present(navigationController, animated: true, completion: nil)
        }
        alertController.addAction(internetImages)
        if withDelete {
            let destroy = UIAlertAction(title: "Удалить фотографию", style: .destructive){ _ in
                // ВНИМАНИЕ! profileImage – вычисляемое свойство класса
                self.model.setNew(photo: UIImage(named: "placeholder-user")!)
                self.model.fetchUpdate()
                let index = IndexPath(row: 0, section: 0)
                self.tableView.reloadRows(at: [index], with: .none)
            }
            alertController.addAction(destroy)
        }
        let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            // ВНИМАНИЕ! profileImage – вычисляемое свойство класса
            model.setNew(photo: pickedImage)
            model.fetchUpdate()
            let index = IndexPath(row: 0, section: 0)
            self.tableView.reloadRows(at: [index], with: .none)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
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
        self.editButton.title = self.model.isEditting ? "Ред." : "Сохранить"
        if self.model.isEditting {
            self.model.saveProfileChanges()
            self.model.fetchUpdate()
        }
        self.model.isEditting = !self.model.isEditting
        let index = IndexSet(integer: 0)
        self.tableView.reloadSections(index, with: .automatic)
    }
    
    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
}
