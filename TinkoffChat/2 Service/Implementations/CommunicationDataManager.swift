//
//  CommunicationDataManager.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 24.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import Foundation
import CoreData

class CommunicationDataManager: CommunicatorDataDelegate, CommunicatorGetDataDelegate {
    
    
    var conversationListVC: ConversationsListProtocol?
    var conversationVC: ConversationProtocol?
    
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
        guard let id = user.userId else {
            return nil
        }
        return TCConversation.get(id: id, in: context)
    }
    
    func getMessages(from conversation: TCConversation) -> [TCMessage] {
        guard let conversationId = conversation.id else {
            return []
        }
        if let messages =  TCMessage.get(conversationId: conversationId, in: context){
            return messages.sorted{ (left, right) in left.date! < right.date!}
        } else {
            return []
        }
    }
    
    
    
    let storageManager: StorageManager
    
    var context: NSManagedObjectContext {
        return storageManager.mainContext
    }
    
    let appUser: TCAppUser
    
    init(storage: StorageManager) {
        storageManager = storage
        appUser = TCAppUser.findOrInsertAppUser(in: storageManager.mainContext)
    }
    
    func didFoundUser(userID: String, userName: String?) {
      //  context.perform {
            if let foundUsed = TCUser.get(withUserId: userID, in: self.context) {
                foundUsed.online = true
                foundUsed.fullName = userName
            } else {
                let newUser = TCUser.insert(in: self.context)
                newUser.userId = userID
                newUser.fullName = userName
                newUser.online = true
                self.appUser.addToUsers(newUser)
            }
            try? self.context.save()
            self.conversationListVC?.update()
     //   }
    }
    
    func didLostUser(userID: String) {
      //  context.perform {
            if let foundUsed = TCUser.get(withUserId: userID, in: self.context) {
                foundUsed.online = false
            }
            try? self.context.save()
            self.conversationListVC?.update()
     //   }
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        
    }
    
    func failedToStartAdvertising(error: Error) {
        
    }
    
    /// Генерация уникального ID для сообщений
    private func generateMessageId() -> String {
        let string = "\(arc4random_uniform(UInt32.max))+\(Date.timeIntervalSinceReferenceDate)+\(arc4random_uniform(UInt32.max))".data(using: .utf8)?.base64EncodedString()
        return string!
    }
    
    func didReceiveMessage(text: String, from userId: String) {
        context.perform {
            if let foundUsed = TCUser.get(withUserId: userId, in: self.context) {
                let conversationId = userId
                let message = TCMessage.insert(in: self.context)
                message.id = self.generateMessageId()
                message.incomming = true
                message.date = Date()
                message.text = text
                message.unread = true
                message.conversationId = conversationId
                message.fromUserId = userId
                message.toUserId = self.appUser.user?.userId
                if let conversation = TCConversation.get(id: conversationId, in: self.context) {
                    message.conversation = conversation
                    message.lastFromConversation = conversation
                } else {
                    let conversation = TCConversation.insert(in: self.context)
                    conversation.id = foundUsed.userId
                    message.conversation = conversation
                    message.lastFromConversation = conversation
                }
            } else {
                print("Пришло сообщение от незнакомца")
            }
            try? self.context.save()
        }
        conversationListVC?.update()
        DispatchQueue.main.async {
            self.conversationVC?.showNewMessage(isIncomming: true)
        }
    }
    
    func sendMessage(text: String, to userId: String) {
        context.perform {
            if let foundUsed = TCUser.get(withUserId: userId, in: self.context) {
                let conversationId = userId
                let message = TCMessage.insert(in: self.context)
                message.id = self.generateMessageId()
                message.incomming = false
                message.date = Date()
                message.text = text
                message.unread = false
                message.fromUserId = self.appUser.user?.userId
                message.toUserId = userId
                message.conversationId = conversationId
                if let conversation =  TCConversation.get(id: conversationId, in: self.context) {
                    message.conversation = conversation
                    message.lastFromConversation = conversation
                } else {
                    let conversation = TCConversation.insert(in: self.context)
                    conversation.id = foundUsed.userId
                    message.conversation = conversation
                    message.lastFromConversation = conversation
                }
            } else {
                //
                //fatalError()
            }
            try? self.context.save()
        }
        conversationListVC?.update()
        DispatchQueue.main.async {
            self.conversationVC?.showNewMessage(isIncomming: false)
        }
    }
    
    
}
