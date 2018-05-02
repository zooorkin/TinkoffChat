//
//  TCConversationListModel.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 01.05.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

struct TCConversationListCellModel {
    let id: String
    let name: String
    let lastMessage: (text: String, date: Date, unread: Bool)?
    let online: Bool
}

protocol ITCConversationListModel {
    var delegate: ITCConversationListModelDelegate? { get set }
    func fetchUpdate()
    func save()
}

protocol ITCConversationListModelDelegate: class {
    func update(dataSource: [TCConversationListCellModel])
}

class TCConversationListModel: ITCConversationListModel, ITCManagerDelegate {

    // MARK: - ITCConversationListModel
    
    weak var delegate: ITCConversationListModelDelegate?
    
    var manager: ITCManager
    
    init(manager: ITCManager) {
        self.manager = manager
        self.manager.firstDelegate = self
    }
    
    func fetchUpdate() {
        let users = manager.getUsers().map{
            (user: TCUser) in
            return { () -> TCConversationListCellModel in
            let id = user.userId!
            let name = user.fullName ?? "unknown"
            let lastMessage: (text: String, date: Date, unread: Bool)?
            if let conversation = manager.getConversation(with: user) {
                if let message = conversation.lastMessage {
                    lastMessage = (text: message.text!, date: message.date!, unread: message.unread)
                } else {
                    lastMessage = nil
                }
            } else {
                lastMessage = nil
            }
            let online = user.online
                return TCConversationListCellModel(id: id, name: name, lastMessage: lastMessage, online: online)}()

        }
        delegate?.update(dataSource: users)
    }
    
    func save() {
        manager.save()
    }
    
    // MARK: - ITCManagerDelegate
    
    func userDidBecomeOnline(userId: String) {
        fetchUpdate()
    }
    
    func userDidBecomeOffine(userId: String) {
        fetchUpdate()
    }
    
    func didReceiveMessage(fromUserWithId: String) {
        fetchUpdate()
    }
    
    func didSendMessage(toUserWithId: String) {
        fetchUpdate()
    }
    
}
