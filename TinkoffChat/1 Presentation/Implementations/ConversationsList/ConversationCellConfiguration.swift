//
//  ConversationCellConfiguration.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 10.03.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import Foundation

protocol ConversationCellConfiguration: class{
    var name: String? {get set}
    var message: String? {get set}
    var date: Date? {get set}
    var online: Bool {get set}
    var hasUnreadMessages: Bool {get set}
}
