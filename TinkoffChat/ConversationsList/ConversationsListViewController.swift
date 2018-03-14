//
//  ConversationsListViewControllerTableViewController.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 08.03.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit

func getOnlineAndHistory(friends: [Friend])->[(header: String, friends: [Friend])]{
    let online = friends.filter{ $0.online}
    let history = friends.filter{ !$0.online}
    let sortedOnline = online.sorted{ $0.date! > $1.date! }
    let sortedHistory = history.sorted{ $0.date! > $1.date! }
    return [(header: "Online", friends: sortedOnline), (header: "History", friends: sortedHistory)]
}

// MARK: - ConversationsList

class ConversationsListViewController: UITableViewController/*,UISearchResultsUpdating */{
    
    // MARK: -
    
    let friends = getOnlineAndHistory(friends: returnFriends())
    
    //let data = getOnlineAndHistory(examples: examples)
    
    var myProfileViewController: UIViewController?
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = 96
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        myProfileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewControllerN")

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
        if let strongMyProfileViewController = myProfileViewController{
        navigationController?.present(strongMyProfileViewController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Navigation
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
