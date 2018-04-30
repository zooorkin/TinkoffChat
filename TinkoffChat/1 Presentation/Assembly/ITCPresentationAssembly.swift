//
//  ITCPresentationAssembly.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 30.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

protocol ITCPresentationAssembly {
    
    var servicesAssembly: ITCServicesAssembly {get}
    init(servicesAssembly: ITCServicesAssembly)

    func navigationController(rootViewController: UIViewController) -> UINavigationController
    func conversationListViewController() -> TCConversationListViewController
    func conversationViewController(user: User) -> TCConversationViewController
    func profileViewController() -> TCProfileViewController
    func themesViewController() -> TCThemesViewController
    
}
