//
//  Communicator.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 05.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import Foundation


protocol CommunicatorDataDelegate: class {
    /// Найден пользователь
    func didFoundUser(userID: String, userName: String?)
    /// Потерян пользователь
    func didLostUser(userID: String)
    /// Ошибка запуска MCNearbyServiceBrowser
    func failedToStartBrowsingForUsers(error: Error)
    /// Ошибка запуска MCNearbyServiceAdvertiser
    func failedToStartAdvertising(error: Error)
    /// Получено сообщение
    func didReceiveMessage(text: String, from userId: String)
    /// Отправка сообщение
    func sendMessage(text: String, to userId: String)
}

protocol CommunicatorGetDataDelegate {
    func getUsers() -> [TCUser]
    func getConversation(with: TCUser) -> TCConversation?
    func getMessages(from: TCConversation) -> [TCMessage]
}

protocol Communicator {
    /// Отправка сообщение
    func sendMessage(text: String,
                     to userID: String,
                     completionHandler:((_ success: Bool, _ error : Error?) -> ())?)
    /// Делегат <CommunicatorDelegate>
    weak var delegate: CommunicatorDataDelegate? {get set}
    var online: Bool {get set}
}

