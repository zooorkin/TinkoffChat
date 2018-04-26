//
//  ServiceAssembly.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 26.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import Foundation

protocol ITCServicesAssembly {
}

class ServicesAssembly: ITCServicesAssembly {
    private let coreAssembly: ITCCoreAssembly
    init(coreAssembly: ITCCoreAssembly) {
        self.coreAssembly = coreAssembly
    }
     lazy var manager: ITCManager = Manager(storage: coreAssembly.storage, communicator: coreAssembly.communicator)
    
}
