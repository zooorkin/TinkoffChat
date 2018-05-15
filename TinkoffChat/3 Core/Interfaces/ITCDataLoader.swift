//
//  ITCDataLoader.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 15.05.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

protocol ITCDataLoader {
    var delegate: ITCDataLoaderDelegate? { get set }
    func getImage(forURL: String, forIndex: Int)
    func getImageURLS(forRequest: String, perPage: Int, page: Int)
}
