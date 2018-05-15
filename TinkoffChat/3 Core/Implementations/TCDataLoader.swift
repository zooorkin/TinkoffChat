//
//  TCDataLoader.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 15.05.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import Foundation

struct InternetImage: Codable {
    let previewURL: String
    let largeImageURL: String
    
}
struct InternetImages: Codable {
    let hits: [InternetImage]
}

class TCDataLoader: ITCDataLoader {
    
    public var delegate: ITCDataLoaderDelegate?

    private let authKey = "9005631-671fb22e44b7dd002b2d9754f"
    
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    func getImageURLS(forRequest: String, perPage: Int, page: Int) {
        let urlString = "https://pixabay.com/api/?key=\(authKey)&q=\(forRequest.replacingOccurrences(of: " ", with: "_"))&image_type=photo&pretty=true&per_page=\(perPage)&page=\(page)"
        guard let url = URL(string: urlString) else {
            return
        }
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?,
            response: URLResponse?,
            error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let data = data {
                let images: InternetImages? = try? self.decoder.decode(InternetImages.self, from: data)
                self.delegate?.didRecievedImageURLS(data: images?.hits.map {$0.previewURL})
                
            }
        }
        task.resume()
    }

    lazy var queue = DispatchQueue(label: "com.tinkoffChat.serial")
    
    func getImage(forURL: String, forIndex: Int) {
        
        queue.sync {
            guard let url = URL(string: forURL) else {
                return
            }
            let request = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request) { (data: Data?,
                response: URLResponse?,
                error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                if let data = data {
                    if let image = UIImage(data: data) {
                        self.delegate?.didRecieved(image: image, index: forIndex)
                    }
                    
                }
            }
            task.resume()
        }
    }

    
}
