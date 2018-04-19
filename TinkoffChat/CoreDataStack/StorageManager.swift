//
//  CoreDataStack.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 12.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import Foundation
import CoreData

class StorageManager {
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


extension Message {
    static func insertConversation(in context: NSManagedObjectContext) -> Message {
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        return message
    }
    
    static func getArrayFrom(set: NSSet?) -> [Message]? {
        if let strongSet = set {
            if let messages = Array(strongSet) as? [Message] {
                return messages
            }
        }
        return nil
    }
    
}

extension Conversation {
    static func insertConversation(in context: NSManagedObjectContext) -> Conversation {
        let conversation = NSEntityDescription.insertNewObject(forEntityName: "Conversation", into: context) as! Conversation
        return conversation
    }
}

extension User {
    
    static func insertUser(in context: NSManagedObjectContext) -> User {
        let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as! User
        return user
    }
    
    static func getArrayFrom(set: NSSet?) -> [User]? {
        if let strongSet = set {
            if let users = Array(strongSet) as? [User] {
                return users
            }
        }
        return nil
    }
    
}

extension AppUser {
    
    static func insertAppUser(in context: NSManagedObjectContext) -> AppUser {
        let appUser = NSEntityDescription.insertNewObject(forEntityName: "AppUser", into: context) as! AppUser
        return appUser
    }
    
    static func fetchRequestAppUser(model: NSManagedObjectModel) -> NSFetchRequest<AppUser>? {
        let templateName = "AppUser"
        guard let fetchRequest = model.fetchRequestTemplate(forName: templateName) as? NSFetchRequest<AppUser> else {
            assert(false, "No template with name \(templateName)")
            return nil
        }
        return fetchRequest
    }
    
    static func findOrInsertAppUser(in context: NSManagedObjectContext) -> AppUser? {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("Model is not available in context!")
            assert(false)
            return nil
        }
        var appUser: AppUser?
        guard let fetchRequest = AppUser.fetchRequestAppUser(model: model) else {
            return nil
        }
        
        do {
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2, "Multiple AppUsers found!")
            if let foundUser = results.first {
                appUser = foundUser
            }
        } catch {
            print("Failed to fetch AppUser: \(error)")
        }
        
        if appUser == nil {
            appUser = AppUser.insertAppUser(in: context)
            appUser?.user = User.insertUser(in: context)
        }
        
        return appUser
    }
    
}





