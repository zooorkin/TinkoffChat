//
//  TCConversationModel.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 01.05.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

struct TCConversationCellModel {
    let id: String
    let text: String
    let date: Date
    let incomming: Bool
    let unread: Bool
    
}

protocol ITCConversationModel {
    var delegate: ITCConversationModelDelegate? { get set }
    func fetchUpdate()
    func send(text: String)
    func save()
}

protocol ITCConversationModelDelegate: class {
    func update(dataSource: [TCConversationCellModel])
    func didRecieveNewMessage()
    func didSendNewMessage()
    func userBecome(online: Bool)
    func showAlertMessage(text: String)
}

class TCConversationModel: ITCConversationModel, ITCManagerDelegate {
    
    weak var delegate: ITCConversationModelDelegate?
    var manager: ITCManager
    let userId: String
    
    init(manager: ITCManager, userId: String) {
        self.manager = manager
        self.userId = userId
        self.manager.secondDelegate = self
    }
    
    func send(text: String){
        DispatchQueue.main.async {
            self.manager.send(message: text, toUserWithUserId: self.userId){
                (success: Bool, error: Error?) in
                if !success{
                    self.delegate?.showAlertMessage(text: "Не удалось отправить сообщение \"\(text)\"")
                }
            }
        }
    }
    
    func fetchUpdate() {
        if let user = manager.getUser(withId: userId) {
            if let conversation = manager.getConversation(with: user) {
                let messages = manager.getMessages(from: conversation)
                var messagesModeled: [TCConversationCellModel] = []
                for message in messages{
                    let id = message.id!
                    let text = message.text!
                    let date = message.date!
                    let incomming = message.incomming
                    let unread = message.unread
                    let x = TCConversationCellModel(id: id, text: text, date: date, incomming: incomming, unread: unread)
                    messagesModeled.append(x)
                }
                delegate?.update(dataSource: messagesModeled)
            }
        }
    }
    
    func save() {
        manager.save()
    }
    
    // MARK: - ITCManagerDelegate
    
    func userDidBecomeOnline(userId: String) {
        fetchUpdate()
        if self.userId == userId {
            delegate?.userBecome(online: true)
        }
    }
    
    func userDidBecomeOffine(userId: String) {
        fetchUpdate()
        if self.userId == userId {
            delegate?.userBecome(online: false)
        }
    }
    
    func didReceiveMessage(fromUserWithId: String) {
        fetchUpdate()
        delegate?.didRecieveNewMessage()
    }
    
    
    func didSendMessage(toUserWithId: String) {
        fetchUpdate()
        delegate?.didSendNewMessage()
    }
    
}
