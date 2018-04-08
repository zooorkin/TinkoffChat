//
//  ConversationsListViewControllerTableViewController.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 08.03.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit

class ConversationsListViewController: UITableViewController, ThemesViewControllerDelegate, ConversationsListProtocol{
    
    // MARK: -

    var communicator = TinkoffCommunicator(userName: "zooorkin")
    
    var manager = CommunicationManager()
    var data: ConversationListData! {
        return manager
    }
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.conversationList = ("zooorkin", self)
        self.communicator.delegate = manager
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = 96
        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = true
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadSection(section: 0, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        manager.conversation = nil
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

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
    
    private func reloadFriend(withName fromUser: String, animated: Bool = true){
        if let index = data.conversationListData.index(where: { $0.id == fromUser}){
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: index, section: 0)
                self.tableView.reloadRows(at: [indexPath], with: animated ? .automatic : .none)
            }
            return
        }
        DispatchQueue.main.async {
            self.tableView.reloadSections(IndexSet(integer: 0), with: animated ? .automatic : .none)
        }
    }
    
    // MARK: - ThemesViewControllerDelegate
    
    private func reloadSection(section: Int, animated: Bool = true){
        DispatchQueue.main.async {
            self.tableView.reloadSections(IndexSet(integer: section), with: animated ? .automatic : .none)
        }
    }
    
    // MARK: - ConversationsListProtocol
    
    public func update(){
        reloadSection(section: 0, animated: true)
    }
    
}
