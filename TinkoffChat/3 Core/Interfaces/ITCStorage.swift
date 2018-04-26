//
//  ITCStorage.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 26.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import Foundation

/// Интерфейс хранилища Tinkoff Chat (Interface of Tinkoff Chat Storage)
protocol ITCStorage {
    func getCurrentUser() -> TCUser
    func getUsers() -> [TCUser]
    func getConversation(with: TCUser) -> TCConversation?
    func getMessages(from: TCConversation) -> [TCMessage]
    func getLastMessage(from: TCConversation) -> TCMessage
    
    func userDidBecomeOnline(userId: String)
    func userDidBecomeOffine(userId: String)
    func didReceive(message: String, fromUserWithId: String)
    func didSend(message: String, toUserWithId: String)
}
