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
    func getUser(withId: String) -> TCUser?
    func getConversation(with: TCUser) -> TCConversation?
    func getMessages(from: TCConversation) -> [TCMessage]
    func getLastMessage(from: TCConversation) -> TCMessage
    func save()
    
    func userDidBecomeOnline(userId: String, withName: String)
    func userDidBecomeOffine(userId: String)
    func didReceive(message: String, fromUserWithId: String, completion: (() -> ())?)
    func didSend(message: String, toUserWithId: String, completion: (() -> ())?)
}
