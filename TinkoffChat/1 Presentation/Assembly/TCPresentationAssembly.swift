//
//  PresentationAssembly.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 26.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

class TCPresentationAssembly: ITCPresentationAssembly {

    
    internal let servicesAssembly: ITCServicesAssembly
    
    required init(servicesAssembly: ITCServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        print("--TCPresentationAssembly has been initialized")
    }
    
    func navigationController(rootViewController: UIViewController) -> UINavigationController{
        return UINavigationController(rootViewController: rootViewController)
    }
    
    func conversationListViewController() -> TCConversationListViewController {
        return TCConversationListViewController(presentationAssembly: self, manager: servicesAssembly.manager)
    }
    
    func conversationViewController(user: User) -> TCConversationViewController {
        return TCConversationViewController(presentationAssembly: self, manager: servicesAssembly.manager, user: user)
    }
    
    func profileViewController() -> TCProfileViewController {
        return TCProfileViewController(presentationAssembly: self, manager: servicesAssembly.manager)
    }
    
    func themesViewController() -> TCThemesViewController {
        return TCThemesViewController(presentationAssembly: self, manager: servicesAssembly.manager)
    }
    
}
