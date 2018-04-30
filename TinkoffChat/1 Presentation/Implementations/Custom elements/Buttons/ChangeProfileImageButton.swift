//
//  ChangeProfileImageButton.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 02.03.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit

@IBDesignable class ChangeProfileImageButton: UIButton {
    
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        if self.frame.height == self.frame.width{
            self.layer.cornerRadius = self.frame.height/2
            self.clipsToBounds = true
        }
        let x = frame.size.width/2
        if let strongImageView = imageView{
            let point = CGPoint(x: x/2, y: x/2)
            let size = CGSize(width: x, height: x)
            strongImageView.frame = CGRect(origin: point, size: size)
        }
    }
    
}
