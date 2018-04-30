//
//  ITCManagerDelegate.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 27.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

protocol ITCManagerDelegate {
    var childDelegate: ITCManagerDelegate? {get}
    func userDidBecomeOnline(userId: String)
    func userDidBecomeOffine(userId: String)
    func didReceiveMessage(fromUserWithId: String)
    func didSendMessage(toUserWithId: String)
}
