//
//  RootAssembly.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 26.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import Foundation

protocol ITCRootAssembly {
    var presentationAssembly: ITCPresentationAssembly {get}
}

class RootAssembly: ITCRootAssembly {
    lazy var presentationAssembly: ITCPresentationAssembly = PresentationAssembly()
    private lazy var serviceAssembly: ITCServicesAssembly = ServicesAssembly(coreAssembly: coreAssembly)
    private lazy var coreAssembly: ITCCoreAssembly = CoreAssembly()
}
