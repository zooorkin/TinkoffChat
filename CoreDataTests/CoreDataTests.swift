//
//  CoreDataTests.swift
//  CoreDataTests
//
//  Created by Андрей Зорькин on 24.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import XCTest
import CoreData

@testable import TinkoffChat

class CoreDataTests: XCTestCase {
    
    var manager: StorageManager?
    
    var context: NSManagedObjectContext {
        return manager!.mainContext
    }
    var model: NSManagedObjectModel {
        return context.model!
    }
    
    override func setUp() {
        super.setUp()
        manager = StorageManager()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        _ = TCAppUser.insert(in: context)
        _ = TCUser.insert(in: context)
        _ = TCConversation.insert(in: context)
        _ = TCMessage.insert(in: context)
        
        _ = TCAppUser.fetchRequest(model: model)
        _ = TCAppUser.findOrInsertAppUser(in: context)
        
        _ = TCUser.fetchRequest(model: model)
        _ = TCUser.fetchRequest(userId: "0", model: model)
        _ = TCUser.getAll(in: context)
        _ = TCUser.get(withUserId: "0", in: context)
        
        _ = TCConversation.fetchRequest(model: model)
        _ = TCConversation.fetchRequest(id: "0", model: model)
        _ = TCConversation.getAll(in: context)
        _ = TCConversation.get(id: "0", in: context)
        
        _ = TCMessage.fetchRequest(model: model)
        _ = TCMessage.fetchRequest(conversationId: "0", model: model)
        _ = TCMessage.getAll(in: context)
        _ = TCMessage.get(conversationId: "0", in: context)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
