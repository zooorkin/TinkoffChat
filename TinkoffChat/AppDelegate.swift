//
//  AppDelegate.swift
//  TinkoffChat
//
//  Created by Андрей Зорькин on 24.02.18.
//  Copyright © 2018 Андрей Зорькин. All rights reserved.
//

import UIKit
import CoreData

func logItApp(from previousState: String, to currentState: String, method: String){
    print("APP         \(previousState)    \(currentState)    \(method)")
}

func logItView(from previousState: String, to currentState: String, method: String){
    print("VIEW        \(previousState)    \(currentState)    \(method)")
}

enum State: String {
    case NotRunning = "Not Running "
    case Inactive =   "Inactive    "
    case Active =     "Active      "
    case Background = "Background  "
    case Suspended =  "Suspended   "
}

enum Object: String{
    case app = "APP "
    case view = "VIEW"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // СОГЛАШЕНИЕ: Процесс запуска приложения (launching) соответствует
    //             состоянию приложения Not Running
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        print("""
                APPLICATION STATES     – Not Running
                                       – Inactive
                                       – Active
                                       – Background
                                       – Suspended

                VIEW CONTROLLER'S      – Appearing
                VIEW'S STATES          – Appeared
                                       – Disappearing
                                       – Disappeared

                Состояние Appearing    – уточнённое состояние Appeared
                Состояние Disappearing – уточнённое состояние Disappeared

                Таким образом, когда View находится в состоянии Appearing (Disappearing), то он
                находится в состоянии Appeared (Disappeared), что соответствует [1].

                СОГЛАШЕНИЕ: Процесс запуска приложения (launching) соответствует состоянию
                            приложения Not Running

                [1] Apple: UIViewController
                    https://developer.apple.com/documentation/uikit/uiviewcontroller

                """)
        print("OBJECT      FROM STATE      TO STATE        METHOD\n")
        logItApp(from: State.NotRunning.rawValue, to: State.NotRunning.rawValue, method: #function)
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        logItApp(from: State.NotRunning.rawValue, to: State.Inactive.rawValue, method: #function)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        logItApp(from: State.Active.rawValue, to: State.Inactive.rawValue, method: #function)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        logItApp(from: State.Inactive.rawValue, to: State.Background.rawValue, method: #function)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        logItApp(from: State.Background.rawValue, to: State.Inactive.rawValue, method: #function)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        logItApp(from: State.Inactive.rawValue, to: State.Active.rawValue, method: #function)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        logItApp(from: State.Background.rawValue, to: State.NotRunning.rawValue, method: #function)
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "TinkoffChat")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

