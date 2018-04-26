//
//  RoundImage.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 08.03.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit

@IBDesignable class RoundImage: UIImageView {

    
    override func layoutSubviews() {
        if self.frame.height == self.frame.width{
            self.layer.cornerRadius = self.frame.height/2
            self.clipsToBounds = true
        }
    }
    
}
