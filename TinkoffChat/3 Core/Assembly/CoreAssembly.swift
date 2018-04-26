//
//  CoreAssembly.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 26.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import Foundation

protocol ITCCoreAssembly {
    var storage: ITCStorage {get}
    var communicator: ITCCommunicator {get}
}

class CoreAssembly: ITCCoreAssembly {
    lazy var storage: ITCStorage = TCStorage()
    lazy var communicator: ITCCommunicator  = TCCommunicator()
}
