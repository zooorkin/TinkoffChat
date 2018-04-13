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
    
    // MARK: - ThemesViewControllerDelegate
    
    func themesViewController(_ controller: UIViewController!, didSelectTheme selectedTheme: UIColor!) {
        let barAppearance = UINavigationBar.appearance()
        barAppearance.barTintColor = selectedTheme
    }
    
    // MARK: - ConversationsListProtocol
    
    public func update(){
        reloadSection(section: 0, animated: true)
    }
    
    // MARK: - Private functions
    
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
    
    private func reloadSection(section: Int, animated: Bool = true){
        DispatchQueue.main.async {
            self.tableView.reloadSections(IndexSet(integer: section), with: animated ? .automatic : .none)
        }
    }
    
}
