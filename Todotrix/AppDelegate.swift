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



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
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
    
    fileprivate func setupAppearance() {
        let navigationBar = UINavigationBar.appearance();
        navigationBar.tintColor = UIColor.white
        navigationBar.barTintColor = UIColor.primaryColor()
        navigationBar.isTranslucent = false
        let titleAttrs = TextAttributes()
            .font(UIFont.defaultFont(size: 19))
            .foregroundColor(UIColor.white)
        navigationBar.titleTextAttributes = titleAttrs.dictionary
        
        let barButtonItem = UIBarButtonItem.appearance()
        let barButtonAttrs = TextAttributes()
            .font(UIFont.defaultFont(size: 15))
            .foregroundColor(UIColor.white)
        barButtonItem.setTitleTextAttributes(barButtonAttrs.dictionary, for: .normal)
        barButtonItem.setTitleTextAttributes(barButtonAttrs.dictionary, for: .highlighted)
        
    }
    
    fileprivate func initFirstUseData() {
        let used = UserDefaults.standard.bool(forKey: "USED")
        if used {
            return
        }
        UserDefaults.standard.set(true, forKey: "USED")
        let service = TodoService.sharedInstance
        
        var t = Todo()
        t.type = Todo.TodoType.importantAndUrgent.rawValue
        t.text = "Swipe down on the screen to create a to-do"
        service.addTodo(t)
        
        t = Todo()
        t.type = Todo.TodoType.important.rawValue
        t.text = "Tap to view the to-do list"
        t.order = 3
        service.addTodo(t)
        
        t = Todo()
        t.type = Todo.TodoType.important.rawValue
        t.text = "Long press to reorder the to-do list"
        t.order = 2
        service.addTodo(t)
        
        t = Todo()
        t.type = Todo.TodoType.important.rawValue
        t.text = "Swipe left to finish a to-do"
        t.order = 1
        service.addTodo(t)
        
        t = Todo()
        t.type = Todo.TodoType.urgent.rawValue
        t.text = "Long press then you can move this todo to other quadrant"
        service.addTodo(t)
        
        t = Todo()
        t.type = Todo.TodoType.urgent.rawValue
        t.text = "Finish a todo by dragging it to the center"
        service.addTodo(t)
        
    }
    
    fileprivate func migrateData() {
        let done = UserDefaults.standard.bool(forKey: "MIGRATED")
        if done {
            return
        }
        UserDefaults.standard.set(true, forKey: "MIGRATED")
        let types = [
            (name: "a", type: Todo.TodoType.importantAndUrgent),
            (name: "b", type: Todo.TodoType.important),
            (name: "c", type: Todo.TodoType.urgent),
            (name: "d", type: Todo.TodoType.other),
        ]
        for config in types {
            let service = OldTodoService(type: config.name)!
            let todos = service.loadAll() as! [[String: AnyObject]]
            for dict in todos {
                let todo = Todo()
                todo.type = config.type.rawValue
                todo.text = dict["content"] as! String
                TodoService.sharedInstance.addTodo(todo)
            }
        }
        
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

