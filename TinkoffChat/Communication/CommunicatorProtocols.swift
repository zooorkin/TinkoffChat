//
//  Communicator.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 05.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import Foundation


protocol CommunicatorDelegate: class {
    /// Найден пользователь
    func didFoundUser(userID: String, userName: String?)
    /// Потерян пользователь
    func didLostUser(userID: String)
    /// Ошибка запуска MCNearbyServiceBrowser
    func failedToStartBrowsingForUsers(error: Error)
    /// Ошибка запуска MCNearbyServiceAdvertiser
    func failedToStartAdvertising(error: Error)
    /// Получено сообщение
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
}

protocol Communicator {
    /// Отправка сообщение
    func sendMessage(string: String,
                     to userID: String,
                     completionHandler:((_ success: Bool, _ error : Error?) -> ())?)
    /// Делегат <CommunicatorDelegate>
    weak var delegate: CommunicatorDelegate? {get set}
    var online: Bool {get set}
}

