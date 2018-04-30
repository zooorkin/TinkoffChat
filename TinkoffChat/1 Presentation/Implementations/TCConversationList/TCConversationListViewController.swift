//
//  TCConversationListViewController.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 29.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit

class TCConversationListViewController: UITableViewController, ITCManagerDelegate, ThemesViewControllerDelegate {
    
    
    var users: [User] = []
    
    internal let presentationAssembly: ITCPresentationAssembly
    internal var manager: ITCManager
    
    init(presentationAssembly: ITCPresentationAssembly, manager: ITCManager) {
        self.presentationAssembly = presentationAssembly
        self.manager = manager
        super.init(nibName: TCNibName.TCConversationList.rawValue, bundle: nil)
        self.manager.delegate = self
        users = manager.getUsers()
        print("----TCConversationListViewController has been initialized")
        print("------Now TCConversationListViewController is delegate of TCManager")
    }
    
    private func reloadData(){
        users = manager.getUsers()
        let index = IndexSet(integer: 0)
        DispatchQueue.main.async {
            self.tableView.reloadSections(index, with: .automatic)
        }
    }
    
    private func adjustNavigationBar(){
        title = "Tinkoff Chat"
        navigationController?.navigationBar.tintColor = UIColor.black
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        if let topItem = navigationController?.navigationBar.topItem {
            let themesButton = UIBarButtonItem(title: "Темы", style: .plain, target: self, action: #selector(openThemesViewController))
            let profileButton = UIBarButtonItem(title: "Мой профиль", style: .plain, target: self, action: #selector(openProfileViewController))
            topItem.leftBarButtonItem = themesButton
            topItem.rightBarButtonItem = profileButton
        } else {
            fatalError()
        }
    }
    
    // MARK: - init

    private func registerNibs() {
        let nib1 = UINib(nibName: TCNibName.TCConversationCell.rawValue, bundle: nil)
        let nib2 = UINib(nibName: TCNibName.TCInformationCell.rawValue, bundle: nil)
        tableView.register(nib1, forCellReuseIdentifier: TCNibName.TCConversationCell.rawValue)
        tableView.register(nib2, forCellReuseIdentifier: TCNibName.TCInformationCell.rawValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        registerNibs()
        adjustNavigationBar()
        super.viewDidLoad()
    }
    
    // MARK: - ITCManagerDelegate
    
    var childDelegate: ITCManagerDelegate?
    
    func userDidBecomeOnline(userId: String) {
        childDelegate?.userDidBecomeOnline(userId: userId)
        reloadData()
    }
    
    func userDidBecomeOffine(userId: String) {
        childDelegate?.userDidBecomeOffine(userId: userId)
        reloadData()
    }
    
    func didReceiveMessage(fromUserWithId: String) {
        childDelegate?.didReceiveMessage(fromUserWithId: fromUserWithId)
        reloadData()
        
    }
    
    func didSendMessage(toUserWithId: String) {
        childDelegate?.didSendMessage(toUserWithId: toUserWithId)
        reloadData()
    }
    
    // MARK: -
    
    @objc private func openProfileViewController() {
        let profileViewController = presentationAssembly.profileViewController()
        let navigationController = presentationAssembly.navigationController(rootViewController: profileViewController)
        self.navigationController?.present(navigationController, animated: true, completion: nil)
    }
    @objc private func openThemesViewController() {
        let themesViewController = presentationAssembly.themesViewController()
        //themesViewController.delegate = self
//        let theme1 = UIColor.white
//        let theme2 = DesignConstants.mediumYellow
//        let theme3 = DesignConstants.salatGreen
//        let themes = Themes.init(theme1, theme2: theme2, theme3: theme3)
//        themesViewController.model = themes
        let navigationController = presentationAssembly.navigationController(rootViewController: themesViewController)
        self.navigationController?.present(navigationController, animated: true)
    }
    
    // MARK: - ThemesViewControllerDelegate
    
    func themesViewController(_ controller: UIViewController!, didSelectTheme selectedTheme: UIColor!) {
        let barAppearance = UINavigationBar.appearance()
        barAppearance.barTintColor = selectedTheme
    }

}
