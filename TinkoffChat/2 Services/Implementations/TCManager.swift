//
//  Manager.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 27.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import Foundation

class TCManager: ITCManager, ITCCommunicatorDelegate {
    
    private var storage: ITCStorage
    private var communicator: ITCCommunicator
    
    // MARK: - Initializator
    
    init(storage: ITCStorage, communicator: ITCCommunicator) {
        self.storage = storage
        self.communicator = communicator
        self.communicator.delegate = self
    }
    
    // MARK: - ITCManager
    
    var firstDelegate: ITCManagerDelegate?
    var secondDelegate: ITCManagerDelegate?
    
    func send(message: String, toUserWithUserId id: String, completionHandler: ((Bool, Error?) -> ())?) {
        self.communicator.send(message: message, toUserWithUserId: id, completionHandler: completionHandler)
    }
    
    func getCurrentUser() -> TCUser {
        return storage.getCurrentUser()
    }

    func getUser(withId id: String) -> TCUser? {
        return storage.getUser(withId: id)
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
    
    func save() {
        storage.save()
    }
    
    // MARK: - ITCCommunicatorDelegate
    
    func userDidBecomeOnline(userId: String, withName: String) {
        print(#function)
        self.storage.userDidBecomeOnline(userId: userId, withName: withName)
        self.firstDelegate?.userDidBecomeOnline(userId: userId)
        self.secondDelegate?.userDidBecomeOnline(userId: userId)
    }
    
    func userDidBecomeOffine(userId: String) {
        print(#function)
        self.storage.userDidBecomeOffine(userId: userId)
        self.firstDelegate?.userDidBecomeOffine(userId: userId)
        self.secondDelegate?.userDidBecomeOffine(userId: userId)
    }
    
    func didReceive(message: String, fromUserWithId: String) {
        print(#function)
        self.storage.didReceive(message: message, fromUserWithId: fromUserWithId){
            () -> () in
            self.firstDelegate?.didReceiveMessage(fromUserWithId: fromUserWithId)
            self.secondDelegate?.didReceiveMessage(fromUserWithId: fromUserWithId)
        }
    }
    
    func didSend(message: String, toUserWithId: String) {
        print(#function)
        self.storage.didSend(message: message, toUserWithId: toUserWithId){
            () -> () in
            self.firstDelegate?.didSendMessage(toUserWithId: toUserWithId)
            self.secondDelegate?.didSendMessage(toUserWithId: toUserWithId)
        }
    }

}
