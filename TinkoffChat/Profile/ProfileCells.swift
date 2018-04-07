//
//  ProfileCells.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 07.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit

class ProfilePhotoCell: UITableViewCell {
    
    @IBOutlet var profilePhoto: UIImageView!
}

class ProfileEdittingPhotoCell: UITableViewCell {
    
}


class ProfileNameCell: UITableViewCell {

    @IBOutlet var profileName: UILabel!
}

class ProfileEdittingNameCell: UITableViewCell {
    
    @IBOutlet var profileName: EditTextView!
}

class ProfileDescriptionCell: UITableViewCell {
    
    @IBOutlet var profileDescription: UILabel!
}

class ProfileEdittingDescriptionCell: UITableViewCell {
    
    @IBOutlet var profileDescription: EditTextView!
}

class ProfileHeaderCell: UITableViewCell {
    
    @IBOutlet var header: UILabel!
}

class ProfileSaveCell: UITableViewCell {
    @IBOutlet var GCDButton: EditButton!
    @IBOutlet var operationButton: EditButton!
    @IBAction func GCDSave(_ sender: Any) {
    }
    @IBAction func operationSave(_ sender: Any) {
    }
    
}
