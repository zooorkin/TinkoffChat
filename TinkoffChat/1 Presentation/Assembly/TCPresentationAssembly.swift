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
    }
    
    func navigationController(rootViewController: UIViewController) -> UINavigationController{
        return UINavigationController(rootViewController: rootViewController)
    }
    
    func conversationListViewController() -> TCConversationListViewController {
        let model = TCConversationListModel(manager: servicesAssembly.manager)
        let conversationListVC = TCConversationListViewController(presentationAssembly: self, model: model)
        model.delegate = conversationListVC
        return conversationListVC
    }
    
    func conversationViewController(userId id: String) -> TCConversationViewController {
        let model = TCConversationModel(manager: servicesAssembly.manager, userId: id)
        let conversationVC = TCConversationViewController(presentationAssembly: self, model: model)
        model.delegate = conversationVC
        return conversationVC
    }
    
    func profileViewController() -> TCProfileViewController {
        let model = TCProfileModel(manager: servicesAssembly.manager)
        let profileVC = TCProfileViewController(presentationAssembly: self, model: model)
        model.delegate = profileVC
        return profileVC
    }
    
    func themesViewController() -> TCThemesViewController {
        return TCThemesViewController(presentationAssembly: self, manager: servicesAssembly.manager)
    }
    
}
