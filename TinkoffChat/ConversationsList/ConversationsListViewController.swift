//
//  ConversationsListViewControllerTableViewController.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 08.03.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit

// MARK: - ConversationsList

class ConversationsListViewController: UITableViewController, ThemesViewControllerDelegate/*,UISearchResultsUpdating */{
    
    // MARK: -
    
    var friends: [(header: String, friends: [Friend])]!
    
    //let data = getOnlineAndHistory(examples: examples)
    
//    var myProfileViewController: UIViewController?
//    var themesViewController: UIViewController?
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friends = getOnlineAndHistory(friends: Friend.returnFriends())
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = 96
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return friends.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return friends[section].friends.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = "ConversationCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: id) as? ConversationCell
        if cell == nil{
            let nib = UINib(nibName: id, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: id)
            cell = tableView.dequeueReusableCell(withIdentifier: id) as? ConversationCell
        }
        if let cellToConfigure = cell{
            let currentFriend = friends[indexPath.section].friends[indexPath.row]
            cellToConfigure.name = currentFriend.name
            cellToConfigure.message = currentFriend.lastMessage
            cellToConfigure.date = currentFriend.date
            cellToConfigure.online = currentFriend.online
            cellToConfigure.hasUnreadMessages = currentFriend.hasUnreadMessages
            return cell!
        }else{
            fatalError()
        }

    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return friends[section].header
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ConversationStoryboard = UIStoryboard(name: "Conversation", bundle: nil)
        let ConversationController = ConversationStoryboard.instantiateViewController(withIdentifier: "ConversationViewController") as! ConversationViewController
        ConversationController.title = friends[indexPath.section].friends[indexPath.row].name
        ConversationController.messages = test
        // Первое слово в строке
        // String(friends[indexPath.section].friends[indexPath.row].name.split(separator: " ")[0])
        navigationController?.pushViewController(ConversationController, animated: true)
        
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
                let theme3 = DesignConstants.pink
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
        let bar = self.navigationController?.navigationBar
        bar?.barTintColor = selectedTheme
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
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
