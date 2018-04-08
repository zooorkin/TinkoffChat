//
//  EditTextView.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 07.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit

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
