//
//  ITCManager.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 26.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

protocol IUser {
    var id: String {get}
    var name: String? {get}
    var info: String? {get}
    var online: Bool {get}
    var photo: UIImage? {get}
}

protocol IConversation {
    var id: String {get}
    var lastMessage: IMessage? {get}
}

protocol IMessage {
    var date: Date? {get}
    var incomming: Bool {get}
    var unread: Bool {get}
    var text: String? {get}
    var id: String {get}
    
}

protocol ITCManager: ITCCommunicatorDelegate/*, ITCStorageDelegate */ {
    func getCurrentUser() -> User
    func getUsers() -> [User]
    func getConversation(with: User) -> Conversation?
    func getMessages(from: Conversation) -> [Message]
    func getLastMessage(from: Conversation) -> Message
    func send(message: String,
              toUserWithUserId: String, completionHandler: ((_ success: Bool, _ error: Error?) -> ())?)
    var delegate: ITCManagerDelegate? {get set}
}
