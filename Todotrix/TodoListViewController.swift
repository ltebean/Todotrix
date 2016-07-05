//
//  TodoListViewController.swift
//  Todotrix
//
//  Created by leo on 16/7/4.
//  Copyright © 2016年 io.ltebean. All rights reserved.
//

import UIKit
import TextAttributes

class TodoCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var todo: Todo! {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        titleLabel.attributedText = todo.text.title()
    }
    
    
    static func heightForTodo(todo: Todo) -> CGFloat {
        let height = todo.text.title().heightWithConstrainedWidth(UIScreen.mainScreen().bounds.width - 30)
        return max(height + 30, 60)
    }
}


class TodoListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let service = TodoService.sharedInstance

    var todos: [Todo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
}

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TodoCell
        cell.todo = todos[indexPath.row]
        cell.showsReorderControl = false
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return TodoCell.heightForTodo(todos[indexPath.row])
    }
    

    
    func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        let todo = todos[fromIndexPath.row]
        todos.removeAtIndex(fromIndexPath.row)
        todos.insert(todo, atIndex: toIndexPath.row)
        service.resetOrder(todos)
    }
    
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let finish = UITableViewRowAction(style: .Normal, title: "Finish") { [weak self] (action, indexPath) in
            let todo = self?.todos[indexPath.row]
            self?.service.deleteTodo(todo!)
            self?.todos.removeAtIndex(indexPath.row)
            self?.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        finish.backgroundColor = UIColor.primaryColor()
        return [finish]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let todo = todos[indexPath.row]
        goToEditor(todo)
    }
    
}

extension TodoListViewController {
    
    func goToEditor(todo: Todo) {
        let vc = R.storyboard.home.input()!
        vc.todo = todo
        vc.willDismiss = {
            self.tableView.reloadData()
        }
        vc.presentInViewController(self)
    }
}


