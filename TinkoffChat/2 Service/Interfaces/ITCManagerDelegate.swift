//
//  ITCManagerDelegate.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 27.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import Foundation

protocol ITCManagerDelegate {
    func userDidBecomeOnline(userId: String)
    func userDidBecomeOffine(userId: String)
    func didReceive(message: String, fromUserWithId: String)
    func didSend(message: String, toUserWithId: String)
}
