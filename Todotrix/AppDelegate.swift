//
//  AppDelegate.swift
//  Todotrix
//
//  Created by leo on 16/5/24.
//  Copyright © 2016年 io.ltebean. All rights reserved.
//

import UIKit
import TextAttributes
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?



    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        setupAppearance()
        initFirstUseData()
        migrateData()
        #if DEBUG
            Heap.setAppId("3339992518")
            Heap.enableVisualizer()
            print("debug")
        #else
            Heap.setAppId("56976480")
            Fabric.with([Crashlytics.self])
        #endif
        return true
    }
    
    private func setupAppearance() {
        let navigationBar = UINavigationBar.appearance();
        navigationBar.tintColor = UIColor.whiteColor()
        navigationBar.barTintColor = UIColor.primaryColor()
        navigationBar.translucent = false
        let titleAttrs = TextAttributes()
            .font(UIFont.defaultFont(size: 19))
            .foregroundColor(UIColor.whiteColor())
        navigationBar.titleTextAttributes = titleAttrs.dictionary
        
        let barButtonItem = UIBarButtonItem.appearance()
        let barButtonAttrs = TextAttributes()
            .font(UIFont.defaultFont(size: 15))
            .foregroundColor(UIColor.whiteColor())
        barButtonItem.setTitleTextAttributes(barButtonAttrs.dictionary, forState: .Normal)
        barButtonItem.setTitleTextAttributes(barButtonAttrs.dictionary, forState: .Highlighted)
        
    }
    
    private func initFirstUseData() {
        let used = NSUserDefaults.standardUserDefaults().boolForKey("USED")
        if used {
            return
        }
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "USED")
        let service = TodoService.sharedInstance
        
        var t = Todo()
        t.type = Todo.TodoType.ImportantAndUrgent.rawValue
        t.text = "Swipe down on the screen to create a to-do"
        service.addTodo(t)
        
        t = Todo()
        t.type = Todo.TodoType.Important.rawValue
        t.text = "Tap to view the to-do list"
        t.order = 3
        service.addTodo(t)
        
        t = Todo()
        t.type = Todo.TodoType.Important.rawValue
        t.text = "Long press to reorder the to-do list"
        t.order = 2
        service.addTodo(t)
        
        t = Todo()
        t.type = Todo.TodoType.Important.rawValue
        t.text = "Swipe left to finish a to-do"
        t.order = 1
        service.addTodo(t)
        
        t = Todo()
        t.type = Todo.TodoType.Urgent.rawValue
        t.text = "Long press then you can move this todo to other quadrant"
        service.addTodo(t)
        
    }
    
    private func migrateData() {
        let done = NSUserDefaults.standardUserDefaults().boolForKey("MIGRATED")
        if done {
            return
        }
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "MIGRATED")
        let types = [
            (name: "a", type: Todo.TodoType.ImportantAndUrgent),
            (name: "b", type: Todo.TodoType.Important),
            (name: "c", type: Todo.TodoType.Urgent),
            (name: "d", type: Todo.TodoType.Other),
        ]
        for config in types {
            let service = OldTodoService(type: config.name)
            let todos = service.loadAll() as! [[String: AnyObject]]
            for dict in todos {
                let todo = Todo()
                todo.type = config.type.rawValue
                todo.text = dict["content"] as! String
                TodoService.sharedInstance.addTodo(todo)
            }
        }
        
    }


    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

