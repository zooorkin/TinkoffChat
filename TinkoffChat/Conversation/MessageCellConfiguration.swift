//
//  MessageCellConfiguration.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 10.03.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import Foundation

protocol MessageCellConfiguration {
    var message: String? {get set}
    var isIncoming: Bool {get set}
    var isUnread: Bool {get set}
    var time: Date{get set}
}
