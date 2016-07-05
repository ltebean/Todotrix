//
//  TodoService.swift
//  Todotrix
//
//  Created by leo on 16/7/4.
//  Copyright © 2016年 io.ltebean. All rights reserved.
//

import UIKit
import RealmSwift

class TodoService: NSObject {
    
    static let sharedInstance = TodoService()

    let realm: Realm
    
    override init() {
        let dir = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.todotrix")!
        let config = Realm.Configuration(
            fileURL: dir.URLByAppendingPathComponent("db.realm")
        )
        realm = try! Realm(configuration: config)
        super.init()
    }

    func loadTodosByType(type: Todo.TodoType) -> [Todo] {
        return realm
            .objects(Todo)
            .filter("type == \(type.rawValue)")
            .sorted("order", ascending: false)
            .flatMap({ e in e})
        
    }
    
    func addTodo(todo: Todo) {
        try! realm.write {
            realm.add(todo, update: true)
        }
    }
    
    func updateTodo(write: (() -> ())) {
        try! realm.write {
            write()
        }
    }
    
    func deleteTodo(todo: Todo) {
        try! realm.write {
            realm.delete(todo)
        }
    }
    
    func resetOrder(todos: [Todo]) {
        try! realm.write {
            for (index, todo) in todos.reverse().enumerate() {
                todo.order = index
            }
        }
    }
    
    
}
