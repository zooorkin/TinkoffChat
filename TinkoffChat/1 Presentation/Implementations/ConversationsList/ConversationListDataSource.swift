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
        if friends.isEmpty {
            return 1
        }else {
            return friends.count + 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if friends.isEmpty{
            guard let iCell = tableView.dequeueReusableCell(withIdentifier: "InformationCell", for: indexPath) as? InformationCell else{
                fatalError()
            }
            iCell.information = "Нет друзей"
            return iCell
        }
        if indexPath.row == friends.count{
            guard let iCell = tableView.dequeueReusableCell(withIdentifier: "InformationCell", for: indexPath) as? InformationCell else{
                fatalError()
            }
            iCell.information = "Друзей: \(friends.count)"
            return iCell
        }
        let id = "ConversationCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: id) as? ConversationCell else{
            fatalError()
        }
        let currentFriend = friends[indexPath.row]
        cell.name = currentFriend.fullName
        if let conversation = dataManager.getConversation(with: currentFriend) {
            if let lastMessage = conversation.lastMessage {
                cell.message = lastMessage.text
                cell.date = lastMessage.date
                cell.hasUnreadMessages = lastMessage.unread
            }
        }
        cell.online = currentFriend.online
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Отжатие информационной ячейки
        if /*manager.conversationListData.count == 0 || */ indexPath.row == friends.count{
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        if !friends[indexPath.row].online{
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        let conversationStoryboard = UIStoryboard(name: "Conversation", bundle: nil)
        let conversationController = conversationStoryboard.instantiateViewController(withIdentifier: "ConversationViewController") as! ConversationViewController
        let friend = friends[indexPath.row]
        conversationController.dataManager = dataManager
        conversationController.withUser = friend
        conversationController.title = friend.fullName
        if let conversation = dataManager.getConversation(with: friend) {
            conversationController.messages = dataManager.getMessages(from: conversation)
        }
        dataManager.conversationVC = conversationController
        conversationController.isUserOnline = true
        conversationController.communicator = self.communicator
        // Первое слово в строке
        // String(friends[indexPath.section].friends[indexPath.row].name.split(separator: " ")[0])
        //self.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(conversationController, animated: true)
        
    }
}
