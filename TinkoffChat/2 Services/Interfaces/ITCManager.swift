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

protocol ITCManager {
    func getCurrentUser() -> TCUser
    func getUser(withId: String) -> TCUser?
    func getUsers() -> [TCUser]
    func getConversation(with: TCUser) -> TCConversation?
    func getMessages(from: TCConversation) -> [TCMessage]
    func getLastMessage(from: TCConversation) -> TCMessage
    func send(message: String,
              toUserWithUserId: String, completionHandler: ((_ success: Bool, _ error: Error?) -> ())?)
    func save()
    var firstDelegate: ITCManagerDelegate? {get set}
    var secondDelegate: ITCManagerDelegate? {get set}
}
