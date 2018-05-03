//
//  TCProfileModel.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 03.05.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import Foundation

//// Cells for ProfileVC

enum TCProfileCellModel {
    case profilePhoto (UIImage)
    case profileName (String)
    case profileDescription (String)
    case profileEdittingPhoto (UIImage)
    case profileEdittingName (String)
    case profileEdittingDescription (String)
    case profileHeader (String)
}

protocol ITCProfileModel {
    var delegate: ITCProfileModelDelegate? { get set }
    var isEditting: Bool { get set }
    func fetchUpdate()
    func setNew(name: String)
    func setNew(info: String)
    func setNew(photo: UIImage)
    func discardProfileChanges()
    func saveProfileChanges()
    func save()
}

protocol ITCProfileModelDelegate: class {
    func update(dataSource: [TCProfileCellModel])
}

class TCProfileModel: ITCProfileModel {
    
    // MARK: - ITCProfileModel
    
    weak var delegate: ITCProfileModelDelegate?
    
    private var manager: ITCManager
    
    private var isEdittingValue: Bool = false
    var isEditting: Bool {
        get {
            return isEdittingValue
        }
        set {
            if newValue != isEdittingValue {
                isEdittingValue = newValue
                fetchUpdate()
            }
        }
    }
    
    init(manager: ITCManager) {
        self.manager = manager
    }
    
    private let defaultProfileImage = UIImage(named: "placeholder-user")
    
    private var newName: String?
    private var newInfo: String?
    private var newPhoto: UIImage?
    
    func fetchUpdate() {
        var dataSource: [TCProfileCellModel] = []
        let currentUser = manager.getCurrentUser()
        
        if !isEdittingValue {
            if let photoData = currentUser.photo {
                if let photo = UIImage(data: photoData) {
                    dataSource.append(.profilePhoto(photo))
                } else {
                    dataSource.append(.profilePhoto(#imageLiteral(resourceName: "placeholder-user")))
                }
            } else {
                dataSource.append(.profilePhoto(#imageLiteral(resourceName: "placeholder-user")))
            }
            let name = currentUser.fullName ?? ""
            dataSource.append(.profileName(name))
            let info = currentUser.info ?? ""
            dataSource.append(.profileDescription(info))
        } else {
            if let photo = newPhoto {
                 dataSource.append(.profileEdittingPhoto(photo))
            } else if let photoData = currentUser.photo {
                if let photo = UIImage(data: photoData) {
                    dataSource.append(.profileEdittingPhoto(photo))
                } else {
                    dataSource.append(.profileEdittingPhoto(#imageLiteral(resourceName: "placeholder-user")))
                }
            } else {
                dataSource.append(.profileEdittingPhoto(#imageLiteral(resourceName: "placeholder-user")))
            }
            dataSource.append(.profileHeader("Имя пользователя"))
            let name = newName ?? currentUser.fullName ?? ""
            dataSource.append(.profileEdittingName(name))
            dataSource.append(.profileHeader("Описание"))
            let info = newInfo ?? currentUser.info ?? ""
            dataSource.append(.profileEdittingDescription(info))
        }
        
        delegate?.update(dataSource: dataSource)
    }
    
    func setNew(name: String) {
        newName = name
    }
    
    func setNew(info: String) {
        newInfo = info
    }
    
    func setNew(photo: UIImage) {
        newPhoto = photo
    }
    
    func discardProfileChanges() {
        newName = nil
        newInfo = nil
        newPhoto = nil
    }
    func saveProfileChanges() {
        let currentUser = manager.getCurrentUser()
        if let name = newName {
            currentUser.fullName = name
            newName = nil
        }
        if let info = newInfo {
            currentUser.info = info
            newInfo = nil
        }
        if let photo = newPhoto {
            if photo.isEqual(defaultProfileImage) {
                currentUser.photo = nil
                newPhoto = nil
            } else {
                currentUser.photo = UIImagePNGRepresentation(photo)
                newPhoto = nil
            }
        }
    }
    
    func save() {
        manager.save()
    }
}
