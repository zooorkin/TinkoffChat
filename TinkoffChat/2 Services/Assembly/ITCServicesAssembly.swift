//
//  ITCServicesAssembly.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 30.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

protocol ITCServicesAssembly {
    var coreAssembly: ITCCoreAssembly {get}
    
    init(coreAssembly: ITCCoreAssembly)
    
    var manager: ITCManager {get}
}
