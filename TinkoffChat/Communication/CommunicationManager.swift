//
//  CommunicationManager.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 05.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import Foundation
import MultipeerConnectivity

/// Интерфейс ConversationList для получения данных
protocol ConversationListData {
    var conversationListData: [Friend] {get}
}

/// Интерфейс ConversationData для получения данных
protocol ConversationData {
    var conversationData: [SimpleMessage] {get}
    var conversationWithUser: String {get}
    func conversationWithFriend() -> Friend?
    func pushNewMessage(_ message: SimpleMessage, toUser: String)
}

class CommunicationManager: CommunicatorDelegate, ConversationListData, ConversationData{
    
    
    var conversationList: (ofUser: String, controller: ConversationsListProtocol)?
    var conversation: (withUser: String, controller: ConversationProtocol,
    messages: [SimpleMessage])?
    
    
    // MARK: - ConversationList
    
    public var conversationListData: [Friend]{
            return friendsRepresentation
    }
    // MARK: - Conversation
    
    public var conversationData: [SimpleMessage]{
            return conversation!.messages
    }
    
    public var conversationWithUser: String {
        return conversation!.withUser
    }
    
    public func conversationWithFriend() -> Friend? {
        if let strongWithUser = conversation?.withUser {
            return friendsData[strongWithUser]
        }else{
            return nil
        }
    }
    
    /// Добавление нового сообщения
    public func pushNewMessage(_ message: SimpleMessage, toUser: String){
        friendsData[toUser]?.lastMessage = message.text
        friendsData[toUser]?.isIncomming = message.isIncoming
        friendsData[toUser]?.date = message.date
        friendsData[toUser]?.hasUnreadMessages = false
        commitFriendsRepresentation()
        conversation?.messages.append(message)
    }
    
    // MARK: - Data
    
    /// Несортированный список друзей
    private var friendsData = [String: Friend]()
    /// Сортированный список друзей
    private var friendsRepresentation = [Friend]()
    
    // MARK: - Управление данными
    
    /// Обновление friendsRepresentation после изменений в friendsData
    private func commitFriendsRepresentation(){
        var friends = [Friend]()
        for eachFriend in friendsData{
            friends += [eachFriend.value]
        }
        friendsRepresentation = friends.sorted{ (left, right) in
            // Сортировка Online-Offline
            if left.online && !right.online {
                return true
            }else if !left.online && right.online {
                return false
            }
            // Сортировка по времени
            if left.date != nil && right.date != nil{
                return left.date! > right.date!
                // Сортировка по наличию сообщения
            }else if left.date == nil && right.date != nil{
                return false
            }else if left.date != nil && right.date == nil{
                return true
                // Сортировка по имени
            }else{
                return left.name > right.name
            }
        }
    }
    
    // MARK: - CommunicatorDelegate
    
    func didFoundUser(userID: String, userName: String?) {
        if friendsData[userID] == nil {
            let friend = Friend(id: userID, name: userName ?? "Неизвестный", lastMessage: nil, isIncomming: nil, date: nil, online: true, hasUnreadMessages: false)
            friendsData[userID] = friend
        }else {
            friendsData[userID]!.online = true
        }
        commitFriendsRepresentation()
        
        conversationList?.controller.update()
        if let strongConversation = conversation{
            if userID == strongConversation.withUser {
                strongConversation.controller.didChangeState(state: .online)
            }
        }
    }
    
    func didLostUser(userID: String) {
        friendsData[userID]?.online = false
        commitFriendsRepresentation()
        
        conversationList?.controller.update()
        if let strongConversation = conversation{
            if userID == strongConversation.withUser {
                strongConversation.controller.didChangeState(state: .offline)
            }
        }
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
    }
    
    func failedToStartAdvertising(error: Error) {
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        friendsData[fromUser]?.id = fromUser
        friendsData[fromUser]?.name = fromUser
        friendsData[fromUser]?.lastMessage = text
        friendsData[fromUser]?.isIncomming = true
        friendsData[fromUser]?.date = Date()
        friendsData[fromUser]?.hasUnreadMessages = true
        commitFriendsRepresentation()
        
        if let strongConversation = conversation, fromUser == strongConversation.withUser{
            let message = SimpleMessage(text: text, isIncoming: true, date: Date())
            conversation?.messages.append(message)
        }
        
        conversationList?.controller.update()
        conversation?.controller.showNewMessage()
    }
    
}
