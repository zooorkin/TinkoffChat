//
//  ProfileImage.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 03.03.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit

@IBDesignable class ProfileView: UIView {
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = DesignConstants.profileImageRadius
        layer.masksToBounds = true
    }
}
