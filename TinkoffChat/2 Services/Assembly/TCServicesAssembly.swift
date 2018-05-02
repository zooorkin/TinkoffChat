//
//  TCServicesAssembly.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 26.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

class TCServicesAssembly: ITCServicesAssembly {
    
    
    internal let coreAssembly: ITCCoreAssembly
    
    required init(coreAssembly: ITCCoreAssembly){
        self.coreAssembly = coreAssembly
    }
    
    lazy var manager: ITCManager = TCManager(storage: coreAssembly.storage, communicator: coreAssembly.communicator)
    
}
