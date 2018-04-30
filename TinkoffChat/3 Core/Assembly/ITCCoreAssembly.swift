//
//  ITCCoreAssembly.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 30.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

protocol ITCCoreAssembly {
    var coreDataStack: ITCCoreDataStack {get}
    var storage: ITCStorage {get}
    var communicator: ITCCommunicator {get}
}
