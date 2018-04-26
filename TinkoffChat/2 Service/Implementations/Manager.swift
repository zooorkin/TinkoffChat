//
//  Manager.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 27.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import Foundation

class Manager: ITCManager, ITCCommunicatorDelegate/*, ITCStorageDelegate */ {
    
    
    private let storage: ITCStorage
    private let communicator: ITCCommunicator
    
    // MARK: - Initializator
    
    init(storage: ITCStorage, communicator: ITCCommunicator) {
        self.storage = storage
        self.communicator = communicator
    }
    
    // MARK: - ITCManager
    
    var delegate: ITCManagerDelegate?
    
    func getCurrentUser() -> TCUser {
        return storage.getCurrentUser()
    }
    
    func getUsers() -> [TCUser] {
        return storage.getUsers()
    }
    
    func getConversation(with user: TCUser) -> TCConversation? {
        return storage.getConversation(with: user)
    }
    
    func getMessages(from conversation: TCConversation) -> [TCMessage] {
        return storage.getMessages(from: conversation)
    }
    
    func getLastMessage(from conversation: TCConversation) -> TCMessage {
        return storage.getLastMessage(from: conversation)
    }
    
    // MARK: - ITCCommunicatorDelegate
    
    func userDidBecomeOnline(userId: String) {
        delegate?.userDidBecomeOnline(userId: userId)
        storage.userDidBecomeOnline(userId: userId)
    }
    
    func userDidBecomeOffine(userId: String) {
        delegate?.userDidBecomeOffine(userId: userId)
       fatalError("\(#function) is not implemented")
    }
    
    func didReceive(message: String, fromUserWithId: String) {
        delegate?.didReceive(message: message, fromUserWithId: fromUserWithId)
        fatalError("\(#function) is not implemented")
    }
    
    func didSend(message: String, toUserWithId: String) {
        delegate?.didSend(message: message, toUserWithId: toUserWithId)
        fatalError("\(#function) is not implemented")
    }
}
