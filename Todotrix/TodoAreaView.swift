//
//  TodoAreaView.swift
//  Todotrix
//
//  Created by leo on 16/5/24.
//  Copyright © 2016年 io.ltebean. All rights reserved.
//

import UIKit

@IBDesignable
class TodoAreaView: XibBasedView {

    var todoType: Todo.TodoType = .Other
    var todos: [Todo] = [] {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var moreLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func load() {
        super.load()
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.borderColor().CGColor
    }
    
    func updateUI() {
        if todos.count == 0 {
            titleLabel.attributedText = "Empty".centeredGrayTitle()
            moreLabel.hidden = true
        } else {
            titleLabel.attributedText = todos.first!.text.centeredTitle()
            moreLabel.hidden = todos.count <= 1
            moreLabel.text = "\(todos.count - 1) more"
        }
    }
    
    func setHighlighted(highlighted: Bool) {
        if highlighted {
            backgroundColor = UIColor.primaryColor().colorWithAlphaComponent(0.1)
        } else {
            backgroundColor = UIColor.whiteColor()
        }
    }
    
}
