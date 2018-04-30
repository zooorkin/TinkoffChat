//
//  EntitiesExtensions.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 24.04.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import Foundation
import CoreData

/*
    Опр. Незначащая ошибка - ошибка, исчезающая при компиляции.
 
    Имена сущностей (префикс TC для того, чтобы IDE Xcode в процессе разработки
    не выдавала незначащих ошибок):
    - TCAppUser
    - TCUser
    - TCConversation
    - TCMessage
 */


// MARK: - Фундамент последующих расширений

extension NSManagedObject {
    
    static func insert<T>(withEntityName entityName: String, in context: NSManagedObjectContext) -> T {
        if let object = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as? T {
            return object
        } else {
            fatalError()
        }
    }
    
    static func fetchRequest<T>(withTemplate templateName: String, model: NSManagedObjectModel) -> NSFetchRequest<T>? {
        guard let fetchRequest = model.fetchRequestTemplate(forName: templateName) as? NSFetchRequest<T> else {
            assert(false, "No template with name \(templateName)")
            return nil
        }
        return fetchRequest
    }
    
    static func fetchRequest<T>(withTemplate templateName: String, model: NSManagedObjectModel, substitutionVariables: [String: Any]) -> NSFetchRequest<T>? {
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: templateName, substitutionVariables: substitutionVariables) as? NSFetchRequest<T> else {
            assert(false, "No template with name \(templateName)")
            return nil
        }
        return fetchRequest
    }
    
}

extension NSManagedObjectContext {
    var model: NSManagedObjectModel? {
        guard let model = self.persistentStoreCoordinator?.managedObjectModel else {
            fatalError("Model is not available in context!")
        }
        return model
    }
}


// MARK: - Вставка новых элементов

extension TCAppUser {
    static func insert(in context: NSManagedObjectContext) -> TCAppUser {
        let entityName = "TCAppUser"
        return NSManagedObject.insert(withEntityName: entityName, in: context)
    }
}

extension TCUser {
    static func insert(in context: NSManagedObjectContext) -> TCUser {
        let entityName = "TCUser"
        return NSManagedObject.insert(withEntityName: entityName, in: context)
    }
}

extension TCConversation {
    static func insert(in context: NSManagedObjectContext) -> TCConversation {
        let entityName = "TCConversation"
        return NSManagedObject.insert(withEntityName: entityName, in: context)
    }
}

extension TCMessage {
    static func insert(in context: NSManagedObjectContext) -> TCMessage {
        let entityName = "TCMessage"
        return NSManagedObject.insert(withEntityName: entityName, in: context)
    }
}

// MARK: - Остальные расширения классов CoreData

extension TCAppUser {
    static func fetchRequest(model: NSManagedObjectModel) -> NSFetchRequest<TCAppUser>? {
        let templateName = "TCAppUserAll"
        return NSManagedObject.fetchRequest(withTemplate: templateName, model: model)
    }
    
    static func findOrInsertAppUser(in context: NSManagedObjectContext) -> TCAppUser {
        guard let model = context.model else {
            print("Model is not available in context!")
            assert(false)
            fatalError()
        }
        var appUser: TCAppUser?
        guard let fetchRequest = TCAppUser.fetchRequest(model: model) else {
            fatalError()
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
            appUser = {
                let temporaryAppUser = TCAppUser.insert(in: context)
                temporaryAppUser.user = TCUser.insert(in: context)
                return temporaryAppUser
            }()
        }
        
        return appUser!
    }
    
}

extension TCUser {
    static func fetchRequest(model: NSManagedObjectModel) -> NSFetchRequest<TCUser>? {
        let templateName = "TCUserAll"
        return NSManagedObject.fetchRequest(withTemplate: templateName, model: model)
    }
    static func fetchRequest(userId: String, model: NSManagedObjectModel) -> NSFetchRequest<TCUser>? {
        let templateName = "TCUserId"
        return NSManagedObject.fetchRequest(withTemplate: templateName, model: model, substitutionVariables: ["ARG": userId])
    }
    static func getAll(in context: NSManagedObjectContext) -> [TCUser]? {
        guard let model = context.model else {
            fatalError()
        }
        guard let fetchRequest = TCUser.fetchRequest(model: model) else {
            fatalError()
        }
        do {
            return try context.fetch(fetchRequest)
        } catch {
            fatalError()
        }
    }
    static func get(withUserId userId: String, in context: NSManagedObjectContext) -> TCUser? {
        guard let model = context.model else {
            fatalError()
        }
        guard let fetchRequest = TCUser.fetchRequest(userId: userId, model: model) else {
            fatalError()
        }
        
        do {
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2, "Multiple Users with the same userId found!")
            return results.first
        } catch {
            fatalError()
        }

    }
}

extension TCConversation {
    static func fetchRequest(model: NSManagedObjectModel) -> NSFetchRequest<TCConversation>? {
        let templateName = "TCConversationAll"
        return NSManagedObject.fetchRequest(withTemplate: templateName, model: model)
    }
    static func fetchRequest(id: String, model: NSManagedObjectModel) -> NSFetchRequest<TCConversation>? {
        let templateName = "TCConversationId"
        return NSManagedObject.fetchRequest(withTemplate: templateName, model: model, substitutionVariables: ["ARG": id])
    }

    static func getAll(in context: NSManagedObjectContext) -> [TCConversation]? {
        guard let model = context.model else {
            fatalError()
        }
        guard let fetchRequest = TCConversation.fetchRequest(model: model) else {
            fatalError()
        }
        do {
            return try context.fetch(fetchRequest)
        } catch {
            fatalError()
        }
    }
    static func get(id: String, in context: NSManagedObjectContext) -> TCConversation? {
        guard let model = context.model else {
            fatalError()
        }
        guard let fetchRequest = TCConversation.fetchRequest(id: id, model: model) else {
            fatalError()
        }
        
        do {
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2)
            return results.first
        } catch {
            fatalError()
        }
        
    }
}

extension TCMessage {
    static func fetchRequest(model: NSManagedObjectModel) -> NSFetchRequest<TCMessage>? {
        let templateName = "TCMessageAll"
        return NSManagedObject.fetchRequest(withTemplate: templateName, model: model)
    }
    static func fetchRequest(conversationId: String, model: NSManagedObjectModel) -> NSFetchRequest<TCMessage>? {
        let templateName = "TCMessagesByConversationId"
        return NSManagedObject.fetchRequest(withTemplate: templateName, model: model, substitutionVariables: ["ARG": conversationId])
    }
    static func getAll(in context: NSManagedObjectContext) -> [TCMessage]? {
        guard let model = context.model else {
            fatalError()
        }
        guard let fetchRequest = TCMessage.fetchRequest(model: model) else {
            fatalError()
        }
        do {
            return try context.fetch(fetchRequest)
        } catch {
            fatalError()
        }
    }
    static func get(conversationId: String, in context: NSManagedObjectContext) -> [TCMessage]? {
        guard let model = context.model else {
            fatalError()
        }
        guard let fetchRequest = TCMessage.fetchRequest(conversationId: conversationId, model: model) else {
            fatalError()
        }
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            fatalError()
        }
        
    }
}
