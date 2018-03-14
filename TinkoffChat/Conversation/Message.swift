//
//  Message.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 08.03.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit

@IBDesignable class Message: UIView {
        
    override func layoutSubviews() {
            self.layer.cornerRadius = CGFloat(18)
            self.clipsToBounds = true
    }
}
