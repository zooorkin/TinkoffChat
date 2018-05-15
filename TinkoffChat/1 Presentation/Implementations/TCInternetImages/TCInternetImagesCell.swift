//
//  TCInternetImagesCell.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 03.05.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit

class TCInternetImagesCell: UICollectionViewCell {
    
    @IBOutlet private var imageView: UIImageView!
    
    public func set(image: UIImage) {
        imageView.image = image
    }
}
