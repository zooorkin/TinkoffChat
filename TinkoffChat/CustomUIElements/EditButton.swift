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


@IBDesignable class ColorButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderWidth = 2
        layer.borderColor = UIColor.darkGray.cgColor
        layer.cornerRadius = DesignConstants.bordedButtonRadius
        clipsToBounds = true
    }
}

@IBDesignable class EditTextView: UITextView {
    
    private var isEditValue: Bool = false
    var isEdit: Bool{
        get{
            return isEditValue
        }
        set{
            isEditValue = newValue
            if (isEditValue){
                backgroundColor = UIColor.groupTableViewBackground
                layer.borderWidth = DesignConstants.bordedButtonBorderWidth
            }else{
                backgroundColor = UIColor.clear
                layer.borderWidth = 0
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = UIColor.clear
        layer.borderWidth = 0
        
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = DesignConstants.bordedButtonRadius
        clipsToBounds = true
    }
}
