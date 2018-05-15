//
//  ITCInternetImagesManager.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 15.05.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import Foundation

protocol ITCInternetImagesManager {
    var delegate: ITCInternetImagesManagerDelegate? { get set }
    func getImageURLS(forRequest: String, perPage: Int, page: Int)
    func getImage(forURL: String, forIndex: Int)
}
