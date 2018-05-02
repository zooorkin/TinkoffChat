//
//  TCCoreAssembly.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 26.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

class TCCoreAssembly: ITCCoreAssembly {
    
    lazy var coreDataStack: ITCCoreDataStack = TCCoreDataStack()
    lazy var storage: ITCStorage = TCStorage(coreDataStack: coreDataStack)
    lazy var communicator: ITCCommunicator  = TCCommunicator(userName: "zooorkin")
}
