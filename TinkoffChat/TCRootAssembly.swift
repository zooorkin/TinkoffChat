//
//  RootAssembly.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 26.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import Foundation

// Ограничение на доступ
protocol ITCRootAssembly {
    var presentationAssembly: ITCPresentationAssembly {get}
}

class TCRootAssembly: ITCRootAssembly {

    lazy var presentationAssembly: ITCPresentationAssembly = TCPresentationAssembly(servicesAssembly: servicesAssembly)
    private lazy var servicesAssembly: ITCServicesAssembly = TCServicesAssembly(coreAssembly: coreAssembly)
    private lazy var coreAssembly: ITCCoreAssembly = TCCoreAssembly()
}
