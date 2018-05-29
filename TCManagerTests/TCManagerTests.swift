//
//  TCManagerTests.swift
//  TCManagerTests
//
//  Created by Андрей Зорькин on 29.05.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import XCTest

@testable import TinkoffChat

class TCManagerTests: XCTestCase {
    
    var root: ITCRootAssembly!
    var manager: TCManager!
    
    override func setUp() {
        super.setUp()
        root = TCRootAssembly()
        if let strongRoot = root {
            if let manager = strongRoot.presentationAssembly.servicesAssembly.manager as? TCManager {
                self.manager = manager
            } else {
                assert(false, "Manager из Root не является классом TCManager")
            }
        } else {
            assert(false, "Root не инициализирован")
        }
    }
    
    override func tearDown() {
        manager = nil
        root = nil
        super.tearDown()
    }
    
    func testSavingNameOfUsers(){
        // GIVEN
        let name = "martingal"
        let id = "player0"
        
        // WHEN
        manager.userDidBecomeOnline(userId: id, withName: name)
    
        // THEN
        if let user = manager.getUser(withId: id) {
            if let savedName = user.fullName {
                XCTAssert(name == savedName, "У только что появившегося пользователя исказилось имя")
            } else {
                XCTAssert(false, "У только что появившегося пользователя имя не было сохранено")
            }
        } else {
            XCTAssert(false, "Только что появившийся пользователь не был найден")
        }
    }
    
    func testChangingNameOfUsers(){
        // GIVEN
        let name1 = "supermartingal"
        let name2 = "submartingal"
        let id = "player1"
        
        // WHEN
        manager.userDidBecomeOnline(userId: id, withName: name1)
        manager.userDidBecomeOffine(userId: id)
        manager.userDidBecomeOnline(userId: id, withName: name2)
        
        // THEN
        if let user = manager.getUser(withId: id) {
            if let savedName = user.fullName {
                XCTAssert(name2 == savedName, "Изменённое имя пользователя не обновилось")
            } else {
                XCTAssert(false, "У только что появившегося пользователя имя не было сохранено")
            }
        } else {
            XCTAssert(false, "Только что появившийся пользователь не был найден")
        }
    }
    
    
    func testGetUser(){
        // GIVEN
        let name = "martingal"
        let id = "player2"
        let wrongId = "..."
        
        // WHEN
        manager.userDidBecomeOnline(userId: id, withName: name)
        
        // THEN
        XCTAssert(manager.getUser(withId: wrongId) == nil, "Только что появившийся пользователь был найден по неверному ID")
    }
    
    func testUserDidBecomeOnline(){
        // GIVEN
        let name = "martingal"
        let id = "player3"
        
        // WHEN
        manager.userDidBecomeOnline(userId: id, withName: name)
        
        // THEN
        if let user = manager.getUser(withId: id) {
            XCTAssert(user.online == true, "Только что появившийся пользователь не не перешёл в статус online")
        } else {
            XCTAssert(false, "Только что появившийся пользователь не был найден")
        }
    }
    
    func testUserDidBecomeOffine(){
        // GIVEN
        let name = "martingal"
        let id = "player4"
        
        // WHEN
        manager.userDidBecomeOnline(userId: id, withName: name)
        manager.userDidBecomeOffine(userId: id)
        
        // THEN
        if let user = manager.getUser(withId: id) {
            XCTAssert(user.online == false, "Пользователь не перешёл в статус offline")
        } else {
            XCTAssert(false, "Только что появившийся пользователь не был найден")
        }
    }
    
}
