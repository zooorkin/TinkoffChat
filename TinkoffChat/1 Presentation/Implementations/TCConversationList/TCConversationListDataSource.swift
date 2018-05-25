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
        if dataSource.isEmpty {
            return 1
        }else {
            return dataSource.count + 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if dataSource.isEmpty{
            guard let iCell = tableView.dequeueReusableCell(withIdentifier: TCNibName.TCInformationCell.rawValue, for: indexPath) as? TCInformationCell else{
                fatalError()
            }
            iCell.information = "Нет друзей"
            return iCell
        }
        if indexPath.row == dataSource.count{
            guard let iCell = tableView.dequeueReusableCell(withIdentifier: TCNibName.TCInformationCell.rawValue, for: indexPath) as? TCInformationCell else{
                fatalError()
            }
            iCell.information = "Друзей: \(dataSource.count)"
            return iCell
        }
        
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: TCNibName.TCConversationCell.rawValue) as? TCConversationCell else {
            fatalError()
        }
        let user = dataSource[indexPath.row]
        cell.name = user.name
        cell.online = user.online
        if let lastMessage = user.lastMessage{
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
        if indexPath.row == dataSource.count {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        let user = dataSource[indexPath.row]

        let conversationController = presentationAssembly.conversationViewController(userId: user.id)

        conversationController.title = user.name
        conversationController.setIsUser(online: user.online, animating: false)
        self.navigationController?.pushViewController(conversationController, animated: true)
    }
}
