//
//  TCCommunicator.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 27.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import Foundation

class TCCommunicator: ITCCommunicator {
    
    
    // MARK: - ITCCommunicator
    
    func send(message: String, toUserWithUserId: String) {
        fatalError("\(#function) is not implemented")
    }
    
    var delegate: ITCCommunicatorDelegate?
    
    
}
