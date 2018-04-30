//
//  TCProfileCells.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 07.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit

class TCProfilePhotoCell: UITableViewCell {
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

class TCProfileEdittingPhotoCell: UITableViewCell {
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

class TCProfileNameCell: UITableViewCell {
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

class TCProfileEdittingNameCell: UITableViewCell {
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

class TCProfileDescriptionCell: UITableViewCell {
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

class TCProfileEdittingDescriptionCell: UITableViewCell {
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

class TCProfileHeaderCell: UITableViewCell {
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
