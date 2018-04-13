//
//  ConversationListDataSource.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 13.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit

extension ConversationsListViewController {
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data.conversationListData.isEmpty {
            return 1
        }else {
            return data.conversationListData.count + 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if data.conversationListData.isEmpty{
            guard let iCell = tableView.dequeueReusableCell(withIdentifier: "InformationCell", for: indexPath) as? InformationCell else{
                fatalError()
            }
            iCell.information = "Нет друзей"
            return iCell
        }
        if indexPath.row == data.conversationListData.count{
            guard let iCell = tableView.dequeueReusableCell(withIdentifier: "InformationCell", for: indexPath) as? InformationCell else{
                fatalError()
            }
            iCell.information = "Друзей: \(data.conversationListData.count)"
            return iCell
        }
        let id = "ConversationCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: id) as? ConversationCell else{
            fatalError()
        }
        let currentFriend = data.conversationListData[indexPath.row]
        cell.name = currentFriend.name
        cell.message = currentFriend.lastMessage
        cell.date = currentFriend.date
        cell.online = currentFriend.online
        cell.hasUnreadMessages = currentFriend.hasUnreadMessages
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Отжатие информационной ячейки
        if /*manager.conversationListData.count == 0 || */ indexPath.row == data.conversationListData.count{
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        if !data.conversationListData[indexPath.row].online{
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        let conversationStoryboard = UIStoryboard(name: "Conversation", bundle: nil)
        let conversationController = conversationStoryboard.instantiateViewController(withIdentifier: "ConversationViewController") as! ConversationViewController
        let friend = data.conversationListData[indexPath.row]
        manager.conversation = (withUser: friend.id, controller: conversationController, messages: [])
        conversationController.manager = manager
        conversationController.title = friend.name
        conversationController.isUserOnline = true
        conversationController.communicator = self.communicator
        // Первое слово в строке
        // String(friends[indexPath.section].friends[indexPath.row].name.split(separator: " ")[0])
        //self.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(conversationController, animated: true)
        
    }
}
