//
//  data.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 08.03.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import Foundation

struct Friend {
    var id: String
    var name: String
    var lastMessage: String?
    var isIncomming: Bool?
    var date: Date?
    var online: Bool
    var hasUnreadMessages: Bool
}




