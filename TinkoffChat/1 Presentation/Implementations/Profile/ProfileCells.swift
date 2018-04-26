//
//  ProfileCells.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 07.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit

class ProfilePhotoCell: UITableViewCell {
    private let defaultProfileImage = UIImage(named: "placeholder-user")
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
    @IBOutlet var profilePhoto: UIImageView!
}

class ProfileEdittingPhotoCell: UITableViewCell {
    private let defaultProfileImage = UIImage(named: "placeholder-user")
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
    @IBOutlet var profilePhoto: UIImageView!
}

class ProfileNameCell: UITableViewCell {
    var name: String? {
        get {
            return profileName.text
        }
        set {
            profileName.text = newValue
        }
    }
    @IBOutlet var profileName: UILabel!
}

class ProfileEdittingNameCell: UITableViewCell {
    var name: String {
        get {
            return profileName.text
        }
        set {
            profileName.text = newValue
        }
    }
    @IBOutlet var profileName: EditTextView!
}

class ProfileDescriptionCell: UITableViewCell {
    var name: String? {
        get {
            return profileDescription.text
        }
        set {
            profileDescription.text = newValue
        }
    }
    @IBOutlet var profileDescription: UILabel!
}

class ProfileEdittingDescriptionCell: UITableViewCell {
    var name: String {
        get {
            return profileDescription.text
        }
        set {
            profileDescription.text = newValue
        }
    }
    @IBOutlet var profileDescription: EditTextView!
}

class ProfileHeaderCell: UITableViewCell {
    var header: String? {
        get {
            return headerLabel.text
        }
        set {
            headerLabel.text = newValue
        }
    }
    @IBOutlet var headerLabel: UILabel!
}
