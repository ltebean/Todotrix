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
        let dir = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.todotrix")!
        let config = Realm.Configuration(
            fileURL: dir.appendingPathComponent("db.realm")
        )
        realm = try! Realm(configuration: config)
        super.init()
    }

    func loadTodosByType(_ type: Todo.TodoType) -> [Todo] {
        return realm
            .objects(Todo.self)
            .filter("type == \(type.rawValue)")
            .sorted(byKeyPath: "order", ascending: false)
            .flatMap({ e in e})
        
    }
    
    func addTodo(_ todo: Todo) {
        try! realm.write {
            realm.add(todo, update: true)
        }
    }
    
    func updateTodo(_ write: (() -> ())) {
        try! realm.write {
            write()
        }
    }
    
    func deleteTodo(_ todo: Todo) {
        try! realm.write {
            realm.delete(todo)
        }
    }
    
    func resetOrder(_ todos: [Todo]) {
        try! realm.write {
            for (index, todo) in todos.reversed().enumerated() {
                todo.order = index
            }
        }
    }
    
    
}
