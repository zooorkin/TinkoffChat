//
//  ITCMessageModel.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 29.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

class Message: IMessage {
    
    let data: TCMessage
    
    init(message: TCMessage) {
        self.data = message
    }
    
    init?(message: TCMessage?) {
        if let strongMessage = message {
            self.data = strongMessage
        } else {
            return nil
        }
    }
    
    var date: Date? {
        return data.date
    }
    
    var incomming: Bool {
        return data.incomming
    }
    
    var unread: Bool {
        return data.unread
    }
    
    var text: String? {
        return data.text
    }
    
    var id: String {
        return data.id!
    }
}
