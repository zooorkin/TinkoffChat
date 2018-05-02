//
//  TCStorage.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 27.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import Foundation
import CoreData

class TCStorage: ITCStorage {

    let coreDataStack: ITCCoreDataStack
    
    var mainContext: NSManagedObjectContext {
        return coreDataStack.mainContext
    }
    
    let appUser: TCAppUser
    
    init(coreDataStack: ITCCoreDataStack) {
        self.coreDataStack = coreDataStack
        appUser = TCAppUser.findOrInsertAppUser(in: coreDataStack.mainContext)
    }
    
    
    // MARK: - ITCStorage
    
    func getCurrentUser() -> TCUser {
        guard let user = appUser.user else {
            fatalError()
        }
        return user
    }
    
    func getUser(withId id: String) -> TCUser? {
        return TCUser.get(withUserId: id, in: mainContext)
    }
    
    func getUsers() -> [TCUser] {
        if let users = appUser.users {
            if let strongUsers = Array(users) as? [TCUser] {
                return strongUsers.sorted{ (left, right) in
                    // Сортировка Online-Offline
                    if left.online && !right.online {
                        return true
                    }else if !left.online && right.online {
                        return false
                    }
                    let leftLM = left.ofConversation?.lastMessage
                    let rightLM = right.ofConversation?.lastMessage
                    
                    // Сортировка по времени
                    if leftLM != nil && rightLM != nil {
                        return leftLM!.date! > rightLM!.date!
                        
                        // Сортировка по наличию сообщения
                    } else if leftLM == nil && rightLM != nil {
                        return false
                    } else if leftLM != nil && rightLM == nil {
                        return true
                    } else {
                        
                        // Сортировка по имени
                        return left.fullName! > right.fullName!
                    }
                }
            } else {
                return []
            }
        } else {
            return []
        }
    }
    
    func getConversation(with user: TCUser) -> TCConversation? {
        return TCConversation.get(id: user.userId!, in: mainContext)
    }
    
    func getMessages(from conversation: TCConversation) -> [TCMessage] {
        guard let conversationId = conversation.id else {
            return []
        }
        if let messages =  TCMessage.get(conversationId: conversationId, in: mainContext){
            return messages.sorted{ (left, right) in left.date! < right.date!}
        } else {
            return []
        }
    }
    
    func getLastMessage(from conversation: TCConversation) -> TCMessage {
        guard let lastMessage = conversation.lastMessage else {
            fatalError()
        }
        return lastMessage
    }
    
    func save() {
        coreDataStack.performSave(context: mainContext, completion: nil)
        print("SAVED")
    }
    
    func userDidBecomeOnline(userId: String, withName userName: String) {
        if let foundUsed = TCUser.get(withUserId: userId, in: self.mainContext) {
            foundUsed.online = true
            foundUsed.fullName = userName
        } else {
            let newUser = TCUser.insert(in: self.mainContext)
            newUser.userId = userId
            newUser.fullName = userName
            newUser.online = true
            self.appUser.addToUsers(newUser)
        }
        //try? self.mainContext.save()
    }
    
    func userDidBecomeOffine(userId: String) {
        if let foundUsed = TCUser.get(withUserId: userId, in: self.mainContext) {
            foundUsed.online = false
        }
        //try? self.mainContext.save()
    }
    
    func didReceive(message text: String, fromUserWithId userId: String, completion: (() -> ())?) {
        mainContext.perform {
            if let foundUsed = TCUser.get(withUserId: userId, in: self.mainContext) {
                let conversationId = userId
                let message = TCMessage.insert(in: self.mainContext)
                message.id = self.generateMessageId()
                message.incomming = true
                message.date = Date()
                message.text = text
                message.unread = true
                message.conversationId = conversationId
                message.fromUserId = userId
                message.toUserId = self.appUser.user?.userId
                if let conversation = TCConversation.get(id: conversationId, in: self.mainContext) {
                    message.conversation = conversation
                    message.lastFromConversation = conversation
                } else {
                    let conversation = TCConversation.insert(in: self.mainContext)
                    conversation.id = foundUsed.userId
                    message.conversation = conversation
                    message.lastFromConversation = conversation
                }
                completion?()
            } else {
                print("Пришло сообщение от незнакомца")
            }
            //try? self.mainContext.save()
        }
    }
    
    func didSend(message text: String, toUserWithId userId: String, completion: (() -> ())?) {
        mainContext.perform {
            if let foundUsed = TCUser.get(withUserId: userId, in: self.mainContext) {
                let conversationId = userId
                let message = TCMessage.insert(in: self.mainContext)
                message.id = self.generateMessageId()
                message.incomming = false
                message.date = Date()
                message.text = text
                message.unread = false
                message.fromUserId = self.appUser.user?.userId
                message.toUserId = userId
                message.conversationId = conversationId
                if let conversation =  TCConversation.get(id: conversationId, in: self.mainContext) {                    message.lastFromConversation = conversation
                    conversation.lastMessage = message
                    conversation.addToMessages(message)
                } else {
                    let conversation = TCConversation.insert(in: self.mainContext)
                    conversation.id = foundUsed.userId
                    message.lastFromConversation = conversation
                    conversation.lastMessage = message
                    conversation.addToMessages(message)
                }
                completion?()
            }
            //try? self.mainContext.save()
        }
    }
    
    /// Генерация уникального ID для сообщений
    private func generateMessageId() -> String {
        let string = "\(arc4random_uniform(UInt32.max))+\(Date.timeIntervalSinceReferenceDate)+\(arc4random_uniform(UInt32.max))".data(using: .utf8)?.base64EncodedString()
        return string!
    }
    
    
}
