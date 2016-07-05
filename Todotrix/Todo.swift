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
        case ImportantAndUrgent = 1
        case Important = 2
        case Urgent = 3
        case Other = 4
    }
    
    dynamic var uuid: String = NSUUID().UUIDString

    dynamic var type = TodoType.Other.rawValue
    dynamic var text = ""
    dynamic var order = Int(NSDate().timeIntervalSince1970)
    dynamic var timeCreated = NSDate()
    dynamic var timeFinished: NSDate?
    
    override static func primaryKey() -> String? {
        return "uuid"
    }
}
