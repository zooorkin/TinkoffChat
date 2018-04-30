//
//  MessageCellConfiguration.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 10.03.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import Foundation

protocol ITCMessageCellConfiguration {
    /// Текст сообщения
    var message: String? {get set}
    /// Сообщение входящее
    var isIncoming: Bool {get set}
    /// Сообщение непрочитанное
    var isUnread: Bool {get set}
    /// Время сообщения
    var time: Date {get set}
}
