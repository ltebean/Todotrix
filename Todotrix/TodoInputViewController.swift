//
//  TodoInputViewController.swift
//  Todotrix
//
//  Created by leo on 16/7/4.
//  Copyright © 2016年 io.ltebean. All rights reserved.
//

import UIKit

class TodoInputViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewTop: NSLayoutConstraint!
  
    @IBOutlet weak var importantButton: UIButton!
    @IBOutlet weak var urgentButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    let service = TodoService.sharedInstance
    var important = false
    var urgent = false
    var willDismiss: (() -> ())?
    
    var todo: Todo?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        containerView.transform.ty = -containerView.frame.height
        
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.borderColor().cgColor
        
        textField.delegate = self

        let tap = UITapGestureRecognizer(target: self, action: #selector(TodoInputViewController.handleTap(_:)))
        view.addGestureRecognizer(tap)
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(TodoInputViewController.handleTap(_:)))
        swipe.direction = .up
        view.addGestureRecognizer(swipe)
        
        if let todo = todo {
            textField.text = todo.text
            importantButton.isHidden = true
            urgentButton.isHidden = true
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        importantButton.scale = 0
        urgentButton.scale = 0

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: [], animations: {
            self.containerView.transform.ty = 0
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.15, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: [], animations: {
            self.importantButton.scale = 1
            self.urgentButton.scale = 1
        }, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.textField.becomeFirstResponder()

    }
    
    func handleTap(_ gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            close()
        }
    }
    
    func close() {
        willDismiss?()
        textField.resignFirstResponder()
        UIView.animate(withDuration: 0.5, delay: 0.15, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: [], animations: {
            self.containerView.transform.ty = -self.containerView.frame.height
        }, completion: { finished in
            self.presentingViewController?.dismiss(animated: false, completion: {})
        })

    }

    
    func presentInViewController(_ viewController: UIViewController) {
        modalPresentationStyle = .custom
        viewController.present(self, animated: false, completion: {})
    }
    
    @IBAction func importantButtonPressed(_ sender: AnyObject) {
        important = !important
        setButtonSelected(importantButton, selected: important)
    }
    
    @IBAction func urgentButtonPressed(_ sender: AnyObject) {
        urgent = !urgent
        setButtonSelected(urgentButton, selected: urgent)
    }
    
    func setButtonSelected(_ button: UIButton, selected: Bool) {
        button.backgroundColor = selected ? UIColor.primaryColor() : UIColor.white
        button.setTitleColor(selected ? UIColor.white : UIColor.primaryColor(), for: UIControlState())
    }
    
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
}

extension TodoInputViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let content = textField.text , content != "" else {
            close()
            return true
        }
        if let todo = todo {
            service.updateTodo({
                todo.text = content
            })
        } else {
            var type = Todo.TodoType.other
            if (important && urgent) {
                type = .importantAndUrgent
            } else if (important) {
                type = .important
            } else if (urgent) {
                type = .urgent
            }
            let todo = Todo()
            todo.text = content
            todo.type = type.rawValue
            service.addTodo(todo)
            
        }
        close()
        return true
    }
}
