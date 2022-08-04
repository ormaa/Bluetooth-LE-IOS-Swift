//
//  AppDelegate.swift
//  CentralManager
//
//  Created by Olivier Robin on 04/03/2017.
//  Copyright © 2017 fr.ormaa. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let singleton = Singleton.sharedInstance()
    
    internal func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        singleton.logger.log("application didFinishLaunchingWithOptions")
        
        singleton.appRestored = false
        singleton.centralManagerToRestore = nil

        registerLocal()

        // if waked up by the system, with bluetooth identifier in parameter :
        // We need to initialize a central manager, with same name.
        // a bluetooth event accoured.
        //
        if let peripheralManagerIdentifiers: [String] = launchOptions?[UIApplication.LaunchOptionsKey.bluetoothCentrals] as? [String]{
            if peripheralManagerIdentifiers.count > 1 {
                // TODO : manage this case
            }
            if peripheralManagerIdentifiers.count == 1 {
                // only one central Manager to initialize again
                let identifier = peripheralManagerIdentifiers.first
                    
                singleton.logger.log("UIApplicationLaunchOptionsKey.bluetoothCentrals] : ")
                singleton.logger.log("App was closed by system. will restore the central manager ")
                singleton.logger.log("--> " + identifier!)

                // flag allowing to know that we need to restore the central manager
                singleton.appRestored = true
                // name of central manager to restore
                singleton.centralManagerToRestore = identifier!
            
            }
        }
        return true
    }


    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay!")
            } else {
                print("D'oh")
            }
        }
    }

    @objc func scheduleLocal() {
        let hour = Calendar.current.component(.hour, from: Date())
        let min = Calendar.current.component(.minute, from: Date())
        let sec = Calendar.current.component(.second, from: Date())

        var dateComponents = DateComponents()
        dateComponents.hour = hour  // 10
        dateComponents.minute = min // 30
        dateComponents.second = sec + 5

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let content = UNMutableNotificationContent()
        content.title = "Title goes here"
        content.body = "Main text goes here"
        content.categoryIdentifier = "customIdentifier"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default

        let center = UNUserNotificationCenter.current()
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        singleton.logger.log("applicationWillResignActive")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        singleton.logger.log("applicationDidEnterBackground")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        singleton.logger.log("applicationWillEnterForeground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        singleton.logger.log("applicationDidBecomeActive")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        singleton.logger.log("applicationWillTerminate")
    }


}

