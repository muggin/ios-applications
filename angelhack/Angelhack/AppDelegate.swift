//
//  AppDelegate.swift
//  Angelhack
//
//  Created by Alexander Juda on 23/05/15.
//  Copyright (c) 2015 Alexander Juda. All rights reserved.
//

import UIKit
import CoreData
import MultipeerConnectivity

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    let messageManager = MessageManager()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
//        sleep(2)
        
        if (!isUserRegistered()) {
            registerWithServer()
        }
        
        messageManager.start()
        
//        enableLogging()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        messageManager.stop()
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        messageManager.stop()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        messageManager.start()
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        messageManager.start()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        messageManager.stop()
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.alexanderjuda.Angelhack" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Angelhack", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Angelhack.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
    
    // MARK: - User Registration support
    
    func isUserRegistered() -> Bool {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        return userDefaults.boolForKey("user_registered")
    }
    
    func registerWithServer() {
        var uuid = UIDevice.currentDevice().identifierForVendor
        var request = NSMutableURLRequest(URL: NSURL(string: "http://21f14d48.ngrok.com/verify")!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        

        var params = "id=\(uuid.UUIDString)"
        var err: NSError?
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        var task = session.dataTaskWithRequest(request) {
            (data, response, error) in
            
            if (error != nil) {
                println("Error during registering with server")
            } else {
                self.saveUserData(data)
            }
        }
        task.resume()
    }
    
    func saveUserData(data: NSData) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var error: NSError?
        
        if let dataDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &error) as? [String: String] {
            if let publicServerKey = dataDictionary["public_key"],
                let id = dataDictionary["id"],
                let name = dataDictionary["name"],
                let signature = dataDictionary["signature"],
                let privateUserKey = dataDictionary["private_key"] {
                    var messageHeader = Message.Header(publicKey: publicServerKey, name: name, id: id, signature: signature)
                    userDefaults.setObject(messageHeader.dictionarialize(), forKey: "message_header")
                    userDefaults.setObject(privateUserKey, forKey: "private_key")
                    userDefaults.setBool(true, forKey: "user_registered")
            } else {
                println("Error saving UserDefaults")
            }
        } else {
            print("Error parsing JSON data")
        }
    }
    
//    func testUserDefaults() {
//        let userDefaults = NSUserDefaults.standardUserDefaults()
//        println(userDefaults.objectForKey("message_header") as! [String: String])
//        println(userDefaults.objectForKey("private_key") as! String)
//        println(userDefaults.boolForKey("user_registered") as Bool)
//    }
    
    func enableLogging() {
        let center = NSNotificationCenter.defaultCenter()
        center.addObserverForName(nil, object: nil, queue: nil) { (notification) -> Void in
            println(notification.name)
        }
    }
}

