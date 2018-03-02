//
//  EditButton.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 03.03.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit

@IBDesignable open class EditButton: UIButton {
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .white
        layer.borderWidth = DesignConstants.bordedButtonBorderWidth
        layer.borderColor = self.titleLabel?.textColor.cgColor ?? UIColor.black.cgColor
        layer.cornerRadius = DesignConstants.bordedButtonRadius
        clipsToBounds = true
    }
}
