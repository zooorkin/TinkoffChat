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
    
    weak var conversation: ConversationViewController?
    var communicator = TinkoffCommunicator(userName: "zooorkin")
    var friendsData = [String: Friend]()
    var friendsRepresentation = [Friend]()

    func updateFriendsRepresentation(){
        var friends = [Friend]()
        for eachFriend in friendsData{
            friends += [eachFriend.value]
        }
        friendsRepresentation = friends.sorted{$0.date! > $1.date!}
        
    }
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = 96
        self.communicator.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let index = tableView.indexPathForSelectedRow{
            tableView.deselectRow(at: index, animated: animated)
            tableView.reloadRows(at: [index], with: .fade)
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
            return tableView.dequeueReusableCell(withIdentifier: "NoDialogs", for: indexPath)
        }
        if indexPath.row == friendsRepresentation.count{
            guard let iCell = tableView.dequeueReusableCell(withIdentifier: "DialogsCountCell", for: indexPath) as? InformationCell else{
                fatalError()
            }
            iCell.information = "Количество диалогов: \(friendsRepresentation.count)"
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
        if indexPath.row == friendsRepresentation.count{
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        let conversationStoryboard = UIStoryboard(name: "Conversation", bundle: nil)
        let conversationController = conversationStoryboard.instantiateViewController(withIdentifier: "ConversationViewController") as! ConversationViewController
        self.conversation = conversationController
        conversationController.title = friendsRepresentation[indexPath.row].name
        conversationController.messages = []
        conversationController.withUserID = friendsRepresentation[indexPath.row].id
        conversationController.communicator = self.communicator
        // Первое слово в строке
        // String(friends[indexPath.section].friends[indexPath.row].name.split(separator: " ")[0])
        navigationController?.pushViewController(conversationController, animated: true)
        
    }
    
    // MARK: - UISearchResultsUpdating
    /*
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    */
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
    
    func logThemeChanging(selectedTheme: UIColor){
        print("ЦВЕТ ИЗМЕНЁН НА: ", terminator: "")
        print(selectedTheme)
    }
    
    func themesViewController(_ controller: UIViewController!, didSelectTheme selectedTheme: UIColor!) {
        let barAppearance = UINavigationBar.appearance()
        barAppearance.barTintColor = selectedTheme
        //let cellAppeatrance = ConversationCell.appearance()
        //tableView.reloadData()
        // ...
        //view.backgroundColor = selectedTheme
        logThemeChanging(selectedTheme: selectedTheme)
    }
    
    // MARK: - Data manipulation functions
    
    private func getOnlineAndHistory(friends: [Friend])->[(header: String, friends: [Friend])]{
        let online = friends.filter{ $0.online}
        let history = friends.filter{ !$0.online}
        let sortedOnline = online.sorted{ $0.date! > $1.date! }
        let sortedHistory = history.sorted{ $0.date! > $1.date! }
        return [(header: "Online", friends: sortedOnline), (header: "History", friends: sortedHistory)]
    }
    
    func didFoundUser(userID: String, userName: String?) {
        let friend = Friend(id: userID, name: userName ?? "Неизвестный", lastMessage: nil, date: nil, online: true, hasUnreadMessages: false)
        friendsData[userID] = friend
        updateFriendsRepresentation()
        DispatchQueue.main.async {
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }
    
    func didLostUser(userID: String) {
        friendsData[userID] = nil
        updateFriendsRepresentation()
        DispatchQueue.main.async {
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        
    }
    
    func failedToStartAdvertising(error: Error) {
        
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        if let strongConversation = conversation {
            if fromUser == conversation?.withUserID{
                strongConversation.didReceiveMessage(text: text)
            }
        }
    }
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
