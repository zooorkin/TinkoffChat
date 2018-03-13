//
//  ChangeProfileImageButton.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 02.03.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//
//  Возвращён

import UIKit

@IBDesignable class ChangeProfileImageButton: UIButton {
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = DesignConstants.profileImageRadius
        clipsToBounds = true
        let x = frame.size.width/2
        if let strongImageView = imageView{
        strongImageView.frame = CGRect(origin: CGPoint(x: x/2, y: x/2) , size: CGSize(width: x, height: x))
        }
    }
}
