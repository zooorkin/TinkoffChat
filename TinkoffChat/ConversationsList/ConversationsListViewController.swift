//
//  ConversationsListViewControllerTableViewController.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 08.03.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit
import CoreData

class ConversationsListViewController: UITableViewController, ThemesViewControllerDelegate{
    
    
    // MARK: -

    var communicator = TinkoffCommunicator(userName: "zooorkin")
    
    // MARK: -
    
    var storageManager = StorageManager()
    private var context: NSManagedObjectContext? {
        return storageManager.mainContext
    }
    
    // MARK: -
    
    private var fetchedResultController: NSFetchedResultsController<Conversation>?
     override func viewDidLoad() {
      super.viewDidLoad()
       self.communicator.delegate = self
        self.tableView.dataSource = self
         self.tableView.delegate = self
          setupFRC()
           fetchData()
            self.tableView.rowHeight = 96
             self.clearsSelectionOnViewWillAppear = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
     if let index = tableView.indexPathForSelectedRow{
      tableView.deselectRow(at: index, animated: animated)
       } else {
        //fatalError()
         }
    }
    
    override func viewDidAppear(_ animated: Bool) {
     }
    
    override func viewWillDisappear(_ animated: Bool) {
     storageManager.performSave(context: storageManager.mainContext, completion: nil)
      }
    
    // MARK: - Private
    
    private func setupFRC() {
     let fetchRequest = NSFetchRequest<Conversation>(entityName: "Conversation")
      let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
       fetchRequest.sortDescriptors = [sortDescriptor]
        guard let context = context else { return }
         fetchedResultController = NSFetchedResultsController<Conversation>(fetchRequest: fetchRequest,
                                                                      managedObjectContext: context,
                                                                      sectionNameKeyPath: nil,
                                                                      cacheName: nil)
        
        fetchedResultController?.delegate = self
    }
    
    private func fetchData() {
        do {
            try fetchedResultController?.performFetch()
        } catch {
            print("Error - \(error), function:" + #function)
        }
    }
    
    
    // MARK: - Actions

    @IBAction func openMyProfile(_ sender: Any) {
     var myProfileViewController: UIViewController?
      let storyboard = UIStoryboard(name: "Profile", bundle: nil)
       myProfileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewControllerN")
        if let x = myProfileViewController?.childViewControllers[0] as? ProfileViewController{
            x.storageManager = storageManager
        } else {
            fatalError()
        }
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
    
    // MARK: - ThemesViewControllerDelegate
    
    func themesViewController(_ controller: UIViewController!, didSelectTheme selectedTheme: UIColor!) {
        let barAppearance = UINavigationBar.appearance()
        barAppearance.barTintColor = selectedTheme
    }
    
}


// MARK: - NSFetchedResultsControllerDelegate

extension ConversationsListViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}


// MARK: - UITableViewDataSource

extension ConversationsListViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let sectionsCount = fetchedResultController?.sections?.count else {
            return 0
        }
        
        return sectionsCount
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultController?.sections else {
            return 0
        }
        
        return sections[section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell") as? ConversationCell else {
            fatalError()
        }
        
        if let friend = fetchedResultController?.object(at: indexPath).friend {
            cell.online = friend.online
             cell.name = friend.name
              cell.message = friend.conversation?.latestMessage?.text
               cell.date = friend.conversation?.latestMessage?.date
                cell.hasUnreadMessages = friend.conversation?.latestMessage?.unread ?? false
        }
        
        return cell
    }
}


extension ConversationsListViewController: CommunicatorDelegate {
    private func friend(userID: String) -> User?{
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        if let friends = try? context?.fetch(fetchRequest) {
            if let strongFriends = friends {
                for eachFriend in strongFriends{
                    if eachFriend.userId == userID {
                        return eachFriend
                    }
                }
            }
        }
        return nil
    }
    
    func didFoundUser(userID: String, userName: String?) {
        if let friend = friend(userID: userID) {
            friend.online = true
        } else {
            let newUser = User.insertUser(in: storageManager.mainContext)
             newUser.userId = userID
              newUser.name = userName
               newUser.online = true
                let conversation = Conversation.insertConversation(in: storageManager.mainContext)
                 conversation.friend = newUser
                  conversation.id = userID
        }
    }
    
    func didLostUser(userID: String) {
        friend(userID: userID)?.online = false
        try? fetchedResultController?.performFetch()
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        
    }
    
    func failedToStartAdvertising(error: Error) {
        
    }
    
    func didReceiveMessage(text: String, fromUserID: String, toUserID: String) {
        func generateMessageId() -> String {
            let string = "MESSAGE+\(arc4random_uniform(UInt32.max))+\(Date.timeIntervalSinceReferenceDate)+\(arc4random_uniform(UInt32.max))".data(using: .utf8)?.base64EncodedString()
            return string!
        }
        if let friend = friend(userID: fromUserID) {
            if friend.conversation == nil {
                let conversation = Conversation.insertConversation(in: storageManager.mainContext)
                conversation.friend = friend
                friend.conversation = conversation
            }
            if let conversation = friend.conversation {
                let message = Message.insertConversation(in: storageManager.mainContext)
                message.id = generateMessageId()
                message.incomming = true
                message.date = Date()
                message.unread = true
                message.text = text
                message.fromConversation = conversation
                conversation.addToMessages(message)
                conversation.latestMessage = message
            }
        }
    }
    
    
}

extension ConversationsListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let conversationStoryboard = UIStoryboard(name: "Conversation", bundle: nil)
        let conversationController = conversationStoryboard.instantiateViewController(withIdentifier: "ConversationViewController") as! ConversationViewController
    
        //conversationController.title = friend.name
        conversationController.withFriend = fetchedResultController?.object(at: indexPath).friend
        conversationController.communicator = communicator
        conversationController.isUserOnline = true
        conversationController.storageManager = storageManager
        // Первое слово в строке
        // String(friends[indexPath.section].friends[indexPath.row].name.split(separator: " ")[0])
        //self.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(conversationController, animated: true)
        
    }
}

