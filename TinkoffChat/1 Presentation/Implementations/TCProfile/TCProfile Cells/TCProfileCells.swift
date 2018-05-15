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

class TCProfileEdittingPhotoCell: UITableViewCell {
    
    public weak var profileViewController: TCProfileViewController?
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
        profileViewController?.changeProfileImage(withDelete: profileImage != nil)
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
