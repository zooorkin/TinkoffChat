//
//  ITCManager.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 26.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import Foundation

protocol ITCManager {
    func getCurrentUser() -> TCUser
    func getUsers() -> [TCUser]
    func getConversation(with: TCUser) -> TCConversation?
    func getMessages(from: TCConversation) -> [TCMessage]
    func getLastMessage(from: TCConversation) -> TCMessage
    
    var delegate: ITCManagerDelegate? {get set}
}
