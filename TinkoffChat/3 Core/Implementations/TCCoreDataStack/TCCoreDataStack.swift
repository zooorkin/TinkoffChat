//
//  TCCoreDataStack.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 30.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import Foundation
import CoreData

protocol ITCCoreDataStack {
    var mainContext: NSManagedObjectContext {get}
    var saveContext: NSManagedObjectContext {get}
    func performSave(context: NSManagedObjectContext, completion: (() -> Void)?)
}

class TCCoreDataStack: ITCCoreDataStack {
    init() {
        print("----TCCoreDataStack has been initialized")
    }
    private var storeURL: URL {
        get {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            return documentsURL.appendingPathComponent("Store.sqlite")
        }
    }
    private let managedObjectModelName = "Storage"
    private lazy var managedObjectModel: NSManagedObjectModel? = {
        guard let modelURL = Bundle.main.url(forResource: managedObjectModelName, withExtension: "momd") else {
            fatalError()
        }
        return NSManagedObjectModel(contentsOf: modelURL)
    }()
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        guard let model = self.managedObjectModel else {
            fatalError()
        }
        let options = [NSMigratePersistentStoresAutomaticallyOption: true,
                       NSInferMappingModelAutomaticallyOption: true]
        let storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        do {
            try storeCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options)
        } catch {
            fatalError()
        }
        return storeCoordinator
    }()
    private lazy var masterContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        context.undoManager = nil
        return context
    }()
    public lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = masterContext
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        context.undoManager = nil
        return context
    }()
    public lazy var saveContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        context.undoManager = nil
        return context
    }()
    
    public func performSave(context: NSManagedObjectContext, completion: (() -> Void)?){
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Context has error: \(error)")
            }
            if let parent = context.parent {
                self.performSave(context: parent, completion: completion)
            } else {
                completion?()
            }
        } else {
            completion?()
        }
    }
}
