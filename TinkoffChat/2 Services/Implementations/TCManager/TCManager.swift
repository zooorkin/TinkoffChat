//
//  Manager.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 27.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import Foundation

class TCManager: ITCManager {
    
    private var storage: ITCStorage
    private var communicator: ITCCommunicator
    
    // MARK: - Initializator
    
    init(storage: ITCStorage, communicator: ITCCommunicator) {
        self.storage = storage
        self.communicator = communicator
        print("----TCManager has been initialized")
        self.communicator.delegate = self
        print("------Now TCManager is delegate of TCCommunicator")
    }
    
    // MARK: - ITCManager
    
    var delegate: ITCManagerDelegate?
    
    func send(message: String, toUserWithUserId id: String, completionHandler: ((Bool, Error?) -> ())?) {
        DispatchQueue.main.async {
            self.communicator.send(message: message, toUserWithUserId: id, completionHandler: completionHandler)
        }
    }
    
    func getCurrentUser() -> User {
        return User(user: storage.getCurrentUser())
    }

    func getUsers() -> [User] {
        return storage.getUsers().map{
            (user: TCUser) in return User(user: user)
        }
    }
    
    func getConversation(with user: User) -> Conversation? {
        return Conversation(conversation: storage.getConversation(with: user.data))
    }
    
    func getMessages(from conversation: Conversation) -> [Message] {
        return storage.getMessages(from: conversation.data).map{
            (message) in return Message(message: message)
        }
    }
    
    func getLastMessage(from conversation: Conversation) -> Message {
        return Message(message: storage.getLastMessage(from: conversation.data))
    }
    
    // MARK: - ITCCommunicatorDelegate
    
    func userDidBecomeOnline(userId: String, withName: String) {
        print(#function)
        storage.userDidBecomeOnline(userId: userId, withName: withName)
        delegate?.userDidBecomeOnline(userId: userId)
    }
    
    func userDidBecomeOffine(userId: String) {
        print(#function)
        storage.userDidBecomeOffine(userId: userId)
        delegate?.userDidBecomeOffine(userId: userId)
    }
    
    func didReceive(message: String, fromUserWithId: String) {
        print(#function)
        storage.didReceive(message: message, fromUserWithId: fromUserWithId)
        delegate?.didReceiveMessage(fromUserWithId: fromUserWithId)
    }
    
    func didSend(message: String, toUserWithId: String) {
        print(#function)
        storage.didSend(message: message, toUserWithId: toUserWithId)
        delegate?.didSendMessage(toUserWithId: toUserWithId)
    }
}
