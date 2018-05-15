//
//  ITCInternetImagesManagerDelegate.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 15.05.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import Foundation

protocol ITCInternetImagesManagerDelegate {
    func didRecievedImageURLS(data: [String]?)
    func didRecieved(image: UIImage, index: Int) 
}
