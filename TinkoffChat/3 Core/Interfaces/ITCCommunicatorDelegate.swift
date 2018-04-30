//
//  ITCCommunicatorDelegate.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 27.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import Foundation

/// Интерфейс делагата коммуникатора Tinkoff Chat (Interface of Tinkoff Chat Communicator Delegate)
protocol ITCCommunicatorDelegate {
    func userDidBecomeOnline(userId: String, withName: String)
    func userDidBecomeOffine(userId: String)
    func didReceive(message: String, fromUserWithId: String)
    func didSend(message: String, toUserWithId: String)
}
