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

    var todoType: Todo.TodoType = .other
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
        layer.borderColor = UIColor.borderColor().cgColor
    }
    
    func updateUI() {
        if todos.count == 0 {
            titleLabel.attributedText = "Empty".centeredGrayTitle()
            moreLabel.isHidden = true
        } else {
            titleLabel.attributedText = todos.first!.text.centeredTitle()
            moreLabel.isHidden = todos.count <= 1
            moreLabel.text = "\(todos.count - 1) more"
        }
    }
    
    func setHighlighted(_ highlighted: Bool) {
        if highlighted {
            backgroundColor = UIColor.primaryColor().withAlphaComponent(0.1)
        } else {
            backgroundColor = UIColor.white
        }
    }
    
}
