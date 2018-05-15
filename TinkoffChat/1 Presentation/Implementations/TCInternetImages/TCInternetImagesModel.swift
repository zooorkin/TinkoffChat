//
//  TCInternetImagesModel.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 15.05.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import Foundation

struct TCInternetImagesCellModel {
    var image: UIImage?
    let urlPreview: String
    var urlLarge: String?
}

protocol ITCInternetImagesModel {
    var delegate: ITCInternetImagesModelDelegate? { get set }
    func fetchUpdate()
    func loadImageAt(index: Int)
}

protocol ITCInternetImagesModelDelegate: class {
    func update(dataSource: [TCInternetImagesCellModel])
    func update(image: UIImage, forIndex: Int)
}

class TCInternetImagesModel: ITCInternetImagesModel, ITCInternetImagesManagerDelegate {
    
    var delegate: ITCInternetImagesModelDelegate?
    var internetImagesManager: ITCInternetImagesManager
    
    var dataSource: [TCInternetImagesCellModel] = []
    
    init(internetImagesManager: ITCInternetImagesManager) {
        self.internetImagesManager = internetImagesManager
        self.internetImagesManager.delegate = self
    }
    
    func fetchUpdate() {
        internetImagesManager.getImageURLS(forRequest: "funny animals", perPage: 120, page: 1)
    }
    
    func loadImageAt(index: Int){
        let url = dataSource[index].urlPreview
        internetImagesManager.getImage(forURL: url, forIndex: index)
    }
    
    func didRecievedImageURLS(data: [String]?) {
        if let data = data {
            dataSource = data.map{ TCInternetImagesCellModel(image: nil, urlPreview: $0, urlLarge: nil)}
            print("Найдено \(dataSource.count) картинок")
            delegate?.update(dataSource: dataSource)
        }
    }
    
    func didRecieved(image: UIImage, index: Int) {
        delegate?.update(image: image, forIndex: index)
    }
    
}

protocol ITCInternetImagesDelegate {
    func setNew(photo: UIImage)
}
