//
//  TCConversationListDataSource.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 29.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import Foundation

extension TCConversationListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if users.isEmpty {
            return 1
        }else {
            return users.count + 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if users.isEmpty{
            guard let iCell = tableView.dequeueReusableCell(withIdentifier: TCNibName.TCInformationCell.rawValue, for: indexPath) as? TCInformationCell else{
                fatalError()
            }
            iCell.information = "Нет друзей"
            return iCell
        }
        if indexPath.row == users.count{
            guard let iCell = tableView.dequeueReusableCell(withIdentifier: TCNibName.TCInformationCell.rawValue, for: indexPath) as? TCInformationCell else{
                fatalError()
            }
            iCell.information = "Друзей: \(users.count)"
            return iCell
        }
        
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: TCNibName.TCConversationCell.rawValue) as? TCConversationCell else {
            fatalError()
        }
        let user = users[indexPath.row]
        cell.name = user.name
        cell.online = user.online
        let conversation = manager.getConversation(with: user)
        if let lastMessage = conversation?.lastMessage {
            cell.date = lastMessage.date
            cell.message = lastMessage.text
            cell.hasUnreadMessages = lastMessage.unread
        }else{
            cell.date = nil
            cell.message = nil
            cell.hasUnreadMessages = false
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    // MARK: -
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Отжатие информационной ячейки
        if indexPath.row == users.count {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        let user = users[indexPath.row]

        let conversationController = presentationAssembly.conversationViewController(user: user)

        conversationController.title = user.name
        conversationController.isUserOnline = user.online
        childDelegate = conversationController
        self.navigationController?.pushViewController(conversationController, animated: true)
    }
}
