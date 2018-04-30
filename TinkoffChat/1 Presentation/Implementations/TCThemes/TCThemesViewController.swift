//
//  TCThemesViewController.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 29.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit

class TCThemesViewController: UIViewController, ITCManagerDelegate {

    
    private let presentationAssembly: ITCPresentationAssembly
    private var manager: ITCManager
    
    init(presentationAssembly: ITCPresentationAssembly, manager: ITCManager) {
        self.presentationAssembly = presentationAssembly
        self.manager = manager
        super.init(nibName: TCNibName.TCThemes.rawValue, bundle: nil)
        print("----TCThemesViewController has been initialized")
        print("------Now TCConversationListViewController is delegate of TCManager")
    }
    
    // MARK: - ITCManagerDelegate
    
    var childDelegate: ITCManagerDelegate?
    
    func userDidBecomeOnline(userId: String) {
        childDelegate?.userDidBecomeOnline(userId: userId)
    }
    
    func userDidBecomeOffine(userId: String) {
        childDelegate?.userDidBecomeOffine(userId: userId)
    }
    
    func didReceiveMessage(fromUserWithId: String) {
        childDelegate?.didReceiveMessage(fromUserWithId: fromUserWithId)
    }
    
    func didSendMessage(toUserWithId: String) {
        childDelegate?.didSendMessage(toUserWithId: toUserWithId)
    }
    
    
    // MARK: - init

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        adjustNavigationBar()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: -
    
    private func adjustNavigationBar(){
        title = "Мой профиль"
        navigationController?.navigationBar.tintColor = UIColor.black
        if let topItem = navigationController?.navigationBar.topItem {
            let leftButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(close))
            let rightButton = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(close))
            topItem.leftBarButtonItem = leftButton
            topItem.rightBarButtonItem = rightButton
        } else {
            fatalError()
        }
    }
    
    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }

}
