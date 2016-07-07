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
        containerView.layer.borderColor = UIColor.borderColor().CGColor
        
        textField.delegate = self

        let tap = UITapGestureRecognizer(target: self, action: #selector(TodoInputViewController.handleTap(_:)))
        view.addGestureRecognizer(tap)
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(TodoInputViewController.handleTap(_:)))
        swipe.direction = .Up
        view.addGestureRecognizer(swipe)
        
        if let todo = todo {
            textField.text = todo.text
            importantButton.hidden = true
            urgentButton.hidden = true
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        importantButton.scale = 0
        urgentButton.scale = 0

        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: [], animations: {
            self.containerView.transform.ty = 0
        }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 0.15, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: [], animations: {
            self.importantButton.scale = 1
            self.urgentButton.scale = 1
        }, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.textField.becomeFirstResponder()

    }
    
    func handleTap(gesture: UITapGestureRecognizer) {
        if gesture.state == .Ended {
            close()
        }
    }
    
    func close() {
        willDismiss?()
        textField.resignFirstResponder()
        UIView.animateWithDuration(0.5, delay: 0.15, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: [], animations: {
            self.containerView.transform.ty = -self.containerView.frame.height
        }, completion: { finished in
            self.presentingViewController?.dismissViewControllerAnimated(false, completion: {})
        })

    }

    
    func presentInViewController(viewController: UIViewController) {
        modalPresentationStyle = .Custom
        viewController.presentViewController(self, animated: false, completion: {})
    }
    
    @IBAction func importantButtonPressed(sender: AnyObject) {
        important = !important
        setButtonSelected(importantButton, selected: important)
    }
    
    @IBAction func urgentButtonPressed(sender: AnyObject) {
        urgent = !urgent
        setButtonSelected(urgentButton, selected: urgent)
    }
    
    func setButtonSelected(button: UIButton, selected: Bool) {
        button.backgroundColor = selected ? UIColor.primaryColor() : UIColor.whiteColor()
        button.setTitleColor(selected ? UIColor.whiteColor() : UIColor.primaryColor(), forState: .Normal)
    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
}

extension TodoInputViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        guard let content = textField.text where content != "" else {
            close()
            return true
        }
        if let todo = todo {
            service.updateTodo({
                todo.text = content
            })
        } else {
            var type = Todo.TodoType.Other
            if (important && urgent) {
                type = .ImportantAndUrgent
            } else if (important) {
                type = .Important
            } else if (urgent) {
                type = .Urgent
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
