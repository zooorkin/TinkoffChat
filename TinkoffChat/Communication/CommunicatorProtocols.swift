//
//  Communicator.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 05.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import Foundation


protocol CommunicatorDelegate: class {
    // Discovering
    func didFoundUser(userID: String, userName: String?)
    func didLostUser(userID: String)
    // Errors
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)
    // Messages
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
    /*
    func failedToSendMessage()
    */
}

protocol Communicator {
    func sendMessage(string: String,
                     to userID: String,
                     completionHandler:((_ success: Bool, _ error : Error?) -> ())?)
    weak var delegate: CommunicatorDelegate? {get set}
    var online: Bool {get set}
}

