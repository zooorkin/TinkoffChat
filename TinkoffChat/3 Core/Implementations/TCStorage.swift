//
//  TCStorage.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 27.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import Foundation

class TCStorage: ITCStorage {
    
    
    // MARK: - ITCStorage
    
    func getCurrentUser() -> TCUser {
        fatalError("\(#function) is not implemented")
    }
    
    func getUsers() -> [TCUser] {
        fatalError("\(#function) is not implemented")
    }
    
    func getConversation(with: TCUser) -> TCConversation? {
        fatalError("\(#function) is not implemented")
    }
    
    func getMessages(from: TCConversation) -> [TCMessage] {
        fatalError("\(#function) is not implemented")
    }
    
    func getLastMessage(from: TCConversation) -> TCMessage {
        fatalError("\(#function) is not implemented")
    }
    
    func userDidBecomeOnline(userId: String) {
        fatalError("\(#function) is not implemented")
    }
    
    func userDidBecomeOffine(userId: String) {
        fatalError("\(#function) is not implemented")
    }
    
    func didReceive(message: String, fromUserWithId: String) {
        fatalError("\(#function) is not implemented")
    }
    
    func didSend(message: String, toUserWithId: String) {
        fatalError("\(#function) is not implemented")
    }
    
    
}
