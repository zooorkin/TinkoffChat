//
//  EditButton.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 03.03.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit

@IBDesignable class EditButton: UIButton {
    
    
    private var isEditValue: Bool = false
    
    var isEdit: Bool{
        get{
            return isEditValue
        }
        set{
            isEditValue = newValue
            if (isEditValue){
                backgroundColor = UIColor.clear
                titleLabel?.textColor = UIColor.lightGray
            }else{
                backgroundColor = DesignConstants.lightYellow
                titleLabel?.textColor = DesignConstants.darkTextYellow
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = DesignConstants.lightYellow
        titleLabel?.textColor = DesignConstants.darkTextYellow
        
        layer.cornerRadius = DesignConstants.bordedButtonRadius
        clipsToBounds = true
    }
    
}
