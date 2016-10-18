//
//  Todo.swift
//  Todotrix
//
//  Created by leo on 16/5/24.
//  Copyright © 2016年 io.ltebean. All rights reserved.
//

import UIKit
import RealmSwift

class Todo: Object {
    
    enum TodoType: Int {
        case importantAndUrgent = 1
        case important = 2
        case urgent = 3
        case other = 4
        
        func description() -> String {
            switch self {
            case .importantAndUrgent:
                return "Important & Urgent"
            case .important:
                return "Important"
            case .urgent:
                return "Urgent"
            case .other:
                return "Other"
            }
        }
    }
    
    dynamic var uuid: String = UUID().uuidString

    dynamic var type = TodoType.other.rawValue
    dynamic var text = ""
    dynamic var order = Int(Date().timeIntervalSince1970)
    dynamic var timeCreated = Date()
    dynamic var timeFinished: Date?
    
    override static func primaryKey() -> String? {
        return "uuid"
    }
}
