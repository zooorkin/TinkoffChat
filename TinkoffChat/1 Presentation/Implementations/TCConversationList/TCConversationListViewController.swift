//
//  TCConversationListViewController.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 29.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit

class TCConversationListViewController: UITableViewController, ITCThemesViewControllerDelegate, ITCConversationListModelDelegate {
    
    
    // MARK: - ITCThemesViewControllerDelegate
    
    func didSelectThemeWith(color: UIColor) {
        let barAppearance = UINavigationBar.appearance()
        barAppearance.barTintColor = color
    }
    
    // MARK: - ITCConversationListModelDelegate
    
    func update(dataSource: [TCConversationListCellModel]) {
        self.dataSource = dataSource
        let index = IndexSet(integer: 0)
        self.tableView.reloadSections(index, with: .automatic)
    }
    
    //
    
    internal let presentationAssembly: ITCPresentationAssembly

    internal let model: ITCConversationListModel
    
    internal var dataSource: [TCConversationListCellModel] = []
    
    // MARK: - init
    
    init(presentationAssembly: ITCPresentationAssembly, model: ITCConversationListModel) {
        self.presentationAssembly = presentationAssembly
        self.model = model
        super.init(nibName: TCNibName.TCConversationList.rawValue, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        registerNibs()
        adjustNavigationBar()
        super.viewDidLoad()
    }
    
    // MARK: -
    
    @objc private func openProfileViewController() {
        let profileViewController = presentationAssembly.profileViewController()
        let navigationController = presentationAssembly.navigationController(rootViewController: profileViewController)
        self.navigationController?.present(navigationController, animated: true, completion: nil)
    }
    @objc private func openThemesViewController() {
        let themesViewController = presentationAssembly.themesViewController()
        themesViewController.delegate = self
        let navigationController = presentationAssembly.navigationController(rootViewController: themesViewController)
        self.navigationController?.present(navigationController, animated: true)
    }
    
    // MARK: - ThemesViewControllerDelegate
    
//    func themesViewController(_ controller: UIViewController!, didSelectTheme selectedTheme: UIColor!) {
//        let barAppearance = UINavigationBar.appearance()
//        barAppearance.barTintColor = selectedTheme
//    }
    
    // MARK: - PRIVATE

    private func adjustNavigationBar(){
        title = "Tinkoff Chat"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Чаты", style: .plain, target: nil, action: nil)
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
    
    private func registerNibs() {
        let nib1 = UINib(nibName: TCNibName.TCConversationCell.rawValue, bundle: nil)
        let nib2 = UINib(nibName: TCNibName.TCInformationCell.rawValue, bundle: nil)
        tableView.register(nib1, forCellReuseIdentifier: TCNibName.TCConversationCell.rawValue)
        tableView.register(nib2, forCellReuseIdentifier: TCNibName.TCInformationCell.rawValue)
    }

}
