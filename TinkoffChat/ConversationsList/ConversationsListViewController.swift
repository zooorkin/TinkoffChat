//
//  ConversationsListViewControllerTableViewController.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 08.03.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit

// MARK: - ConversationsList

class ConversationsListViewController: UITableViewController, ThemesViewControllerDelegate, CommunicatorDelegate{
    
    // MARK: -
    
    var conversation: ConversationViewController?
    var communicator = TinkoffCommunicator(userName: "zooorkin")
    var friendsData = [String: Friend]()
    
    var friendsRepresentation = [Friend]()

    func updateFriendsRepresentation(){
        var friends = [Friend]()
        for eachFriend in friendsData{
            friends += [eachFriend.value]
        }
        friendsRepresentation = friends.sorted{ (left, right) in
            if left.date != nil && right.date != nil{
                return left.date! > right.date!
            }else if left.date == nil && right.date != nil{
                return false
            }else if left.date != nil && right.date == nil{
                return true
            }else{
                return left.name > right.name
            }
        }
    }
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = 96
        self.communicator.delegate = self
        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = true

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let userID = conversation?.withUserID{
            if let lastMessage = conversation?.messages.last{
                friendsData[userID]?.lastMessage = lastMessage.message
                friendsData[userID]?.date = lastMessage.date
                friendsData[userID]?.isIncomming = lastMessage.isIncoming
                friendsData[userID]?.hasUnreadMessages = false
                updateFriendsRepresentation()
            }
            reloadFriend(withName: userID, animated: false)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        conversation = nil
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if friendsRepresentation.isEmpty {
            return 1
        }else {
            return friendsRepresentation.count + 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if friendsRepresentation.isEmpty{
            guard let iCell = tableView.dequeueReusableCell(withIdentifier: "InformationCell", for: indexPath) as? InformationCell else{
                fatalError()
            }
            iCell.information = "Нет друзей"
            return iCell
        }
        if indexPath.row == friendsRepresentation.count{
            guard let iCell = tableView.dequeueReusableCell(withIdentifier: "InformationCell", for: indexPath) as? InformationCell else{
                fatalError()
            }
            iCell.information = "Друзей: \(friendsRepresentation.count)"
            return iCell
        }
        let id = "ConversationCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: id) as? ConversationCell else{
            fatalError()
        }
        let currentFriend = friendsRepresentation[indexPath.row]
        cell.name = currentFriend.name
        cell.message = currentFriend.lastMessage
        cell.date = currentFriend.date
        cell.online = currentFriend.online
        cell.hasUnreadMessages = currentFriend.hasUnreadMessages
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Отжатие информационной ячейки
        if /*friendsRepresentation.count == 0 || */ indexPath.row == friendsRepresentation.count{
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        if !friendsRepresentation[indexPath.row].online{
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        let conversationStoryboard = UIStoryboard(name: "Conversation", bundle: nil)
        let conversationController = conversationStoryboard.instantiateViewController(withIdentifier: "ConversationViewController") as! ConversationViewController
        self.conversation = conversationController
        let friend = friendsRepresentation[indexPath.row]
        conversationController.title = friend.name
        if friend.lastMessage != nil{
            conversationController.messages = [(message: friend.lastMessage!, isIncoming: friend.isIncomming!, date: friend.date!)]
        }else{
            conversationController.messages = []
        }
        conversationController.withUserID = friend.id
        conversationController.communicator = self.communicator
        // Первое слово в строке
        // String(friends[indexPath.section].friends[indexPath.row].name.split(separator: " ")[0])
        //self.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(conversationController, animated: true)
        
    }
    
    // MARK: - Actions

    @IBAction func openMyProfile(_ sender: Any) {
        var myProfileViewController: UIViewController?
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        myProfileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewControllerN")
        navigationController?.present(myProfileViewController!, animated: true, completion: nil)
    }
    
    @IBAction func openThemesViewController(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ThemesViewController", bundle: nil)
        let navigatorWithThemesVC = storyboard.instantiateViewController(withIdentifier: "ThemesN")
        if navigatorWithThemesVC.childViewControllers.count > 0{
            if let themesVC = navigatorWithThemesVC.childViewControllers[0] as? ThemesViewController{
                themesVC.delegate = self
                let theme1 = UIColor.white
                let theme2 = DesignConstants.mediumYellow
                let theme3 = DesignConstants.salatGreen
                let themes = Themes.init(theme1, theme2: theme2, theme3: theme3)
                themesVC.model = themes
            }
        }
        navigationController?.present(navigatorWithThemesVC, animated: true)
    }
    
    func themesViewController(_ controller: UIViewController!, didSelectTheme selectedTheme: UIColor!) {
        let barAppearance = UINavigationBar.appearance()
        barAppearance.barTintColor = selectedTheme
    }
    
    // MARK: - CommunicatorDelegate
    
    func didFoundUser(userID: String, userName: String?) {
        let friend = Friend(id: userID, name: userName ?? "Неизвестный", lastMessage: nil, isIncomming: nil, date: nil, online: true, hasUnreadMessages: false)
        friendsData[userID] = friend
        updateFriendsRepresentation()
        DispatchQueue.main.async {
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }
    
    func didLostUser(userID: String) {
        friendsData[userID]?.online = false
        updateFriendsRepresentation()
        reloadFriend(withName: userID)
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        
    }
    
    func failedToStartAdvertising(error: Error) {
        
    }
    
    private func reloadFriend(withName fromUser: String, animated: Bool = true){
        if let friend = friendsData[fromUser]{
            if let index = friendsRepresentation.index(where: { $0.id == friend.id}){
                DispatchQueue.main.async {
                    let indexPath = IndexPath(row: index, section: 0)
                    self.tableView.reloadRows(at: [indexPath], with: animated ? .automatic : .none)
                }
                return
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        if let strongConversation = conversation {
            if fromUser == conversation?.withUserID{
                strongConversation.didReceiveMessage(text: text)
            }
        }else{
            friendsData[fromUser]?.id = fromUser
            friendsData[fromUser]?.name = fromUser
            friendsData[fromUser]?.lastMessage = text
            friendsData[fromUser]?.isIncomming = true
            friendsData[fromUser]?.date = Date()
            friendsData[fromUser]?.hasUnreadMessages = true
            updateFriendsRepresentation()
            reloadFriend(withName: fromUser)
        }
    }

}
