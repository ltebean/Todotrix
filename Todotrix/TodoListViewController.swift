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
    
}


class TodoListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let service = TodoService.sharedInstance

    var todos: [Todo] = []
    var counter = 1
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(update), userInfo: nil, repeats: true)

        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
    
    func update() {
        let todo = Todo()
        todo.text = UUID().uuidString
        todo.type = todos[0].type
        todos.append(todo)
        tableView.reloadData()
        tableView.layoutIfNeeded()
        //        DispatchQueue.main.async {
        self.tableView.scrollToRow(at: IndexPath(row: self.todos.count - 1, section: 0), at: .top, animated: true)
        
        //        }
    }
    
}

extension TodoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TodoCell
        cell.todo = todos[(indexPath as NSIndexPath).row]
        cell.showsReorderControl = false
        return cell
    }
    

    
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        let todo = todos[(fromIndexPath as NSIndexPath).row]
        todos.remove(at: (fromIndexPath as NSIndexPath).row)
        todos.insert(todo, at: (toIndexPath as NSIndexPath).row)
        service.resetOrder(todos)
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let finish = UITableViewRowAction(style: .normal, title: "Finish") { [weak self] (action, indexPath) in
            let todo = self?.todos[(indexPath as NSIndexPath).row]
            self?.service.deleteTodo(todo!)
            self?.todos.remove(at: (indexPath as NSIndexPath).row)
            self?.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        finish.backgroundColor = UIColor.primaryColor()
        return [finish]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = todos[(indexPath as NSIndexPath).row]
        goToEditor(todo)
    }
    
}

extension TodoListViewController {
    
    func goToEditor(_ todo: Todo) {
        let vc = R.storyboard.home.input()!
        vc.todo = todo
        vc.willDismiss = {
            self.tableView.reloadData()
        }
        vc.presentInViewController(self)
    }
}


