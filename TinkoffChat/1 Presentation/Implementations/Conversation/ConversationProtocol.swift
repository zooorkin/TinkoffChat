//
//  ConversationProtocol.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 08.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit

protocol ConversationProtocol {
    /// Уведомление об изменении online статуса собеседника
    func didChangeState(state: ConversationState)
    /// Уведомление о наличии новго сообщения, которое необходимо показать
    func showNewMessage(isIncomming: Bool)
}
