//
//  ColorButton.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 08.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit

@IBDesignable class ColorButton: UIButton {
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderWidth = 1
        layer.borderColor = UIColor.darkGray.cgColor
        layer.cornerRadius = DesignConstants.bordedButtonRadius
        clipsToBounds = true
    }
    
}
