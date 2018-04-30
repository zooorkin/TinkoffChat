//
//  ITCCommunicator.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 26.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import Foundation

/// Интерфейс коммуникатора Tinkoff Chat (Interface of Tinkoff Chat Communicator)
protocol ITCCommunicator{
    func send(message: String,
              toUserWithUserId: String, completionHandler: ((_ success: Bool, _ error: Error?) -> ())?)
    var delegate: ITCCommunicatorDelegate? {get set}
}

