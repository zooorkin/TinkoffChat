//
//  ITCConversationModel.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 29.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

class Conversation: IConversation {
    
    let data: TCConversation
    
    init?(conversation: TCConversation?) {
        if let stringConversation = conversation {
            self.data = stringConversation
        } else {
            return nil
        }
    }
    
    var id: String {
        return data.id!
    }
    
    var lastMessage: IMessage? {
        if let strongMessage = data.lastMessage {
            return Message(message: strongMessage)
        } else {
            return nil
        }
    }
}

