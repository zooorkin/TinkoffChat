//
//  TCInternetImagesManager.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 15.05.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import Foundation

class TCInternetImagesManager: ITCInternetImagesManager, ITCDataLoaderDelegate {
   
    
    var delegate: ITCInternetImagesManagerDelegate?

    var dataLoader: ITCDataLoader
    
    lazy var queue = DispatchQueue(label: "com.tinkoffChat.iimanager")
    
    init(dataLoader: ITCDataLoader) {
        self.dataLoader = dataLoader
        self.dataLoader.delegate = self
    }
    
    func getImageURLS(forRequest: String, perPage: Int, page: Int) {
        queue.async {
            self.dataLoader.getImageURLS(forRequest: forRequest, perPage: perPage, page: page)
        }
    }
    
    func getImage(forURL: String, forIndex: Int) {
        queue.async {
            self.dataLoader.getImage(forURL: forURL, forIndex: forIndex)
        }
    }
    func didRecievedImageURLS(data: [String]?) {
        queue.sync {
            delegate?.didRecievedImageURLS(data: data)
        }
    }
    func didRecieved(image: UIImage, index: Int) {
        queue.sync {
            delegate?.didRecieved(image: image, index: index)
        }
    }
    
}
