//
//  HomeViewController.swift
//  Todotrix
//
//  Created by leo on 16/5/24.
//  Copyright © 2016年 io.ltebean. All rights reserved.
//

import UIKit
import VBFPopFlatButton

class HomeViewController: UIViewController {

    @IBOutlet weak var area1: TodoAreaView!
    @IBOutlet weak var area2: TodoAreaView!
    @IBOutlet weak var area3: TodoAreaView!
    @IBOutlet weak var area4: TodoAreaView!
    
    var menuButton: VBFPopFlatButton!
    var inputButton: VBFPopFlatButton!

    var areaViews: [TodoAreaView] = []
    
    var snapshotView: UIView!
    var todoDragging: Todo!
    var startCenter: CGPoint!
    var startLocation: CGPoint!
    var loaded = false
    
    let service = TodoService.sharedInstance
    let transitionDelegate = HomeTransitionDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.view.backgroundColor = UIColor(hex: 0xf0f0f0)
        navigationController?.delegate = transitionDelegate
        
      
        menuButton = VBFPopFlatButton(frame: CGRectMake(0, 0, 22, 22), buttonType: FlatButtonType.buttonMenuType, buttonStyle: FlatButtonStyle.buttonPlainStyle, animateToInitialState: false)
        menuButton.lineRadius = 1
        menuButton.addTarget(self, action: #selector(HomeViewController.menuButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
        
        inputButton = VBFPopFlatButton(frame: CGRectMake(0, 0, 20, 20), buttonType: FlatButtonType.buttonAddType, buttonStyle: FlatButtonStyle.buttonPlainStyle, animateToInitialState: false)
        inputButton.lineRadius = 1
        inputButton.addTarget(self, action: #selector(HomeViewController.inputButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: inputButton)
        
        area1.todoType = .ImportantAndUrgent
        area2.todoType = .Important
        area3.todoType = .Urgent
        area4.todoType = .Other
        
        areaViews = [area1, area2, area3, area4];
        
        let drag = UILongPressGestureRecognizer(target: self, action: #selector(HomeViewController.handleDrag(_:)))
        drag.minimumPressDuration = 0.3
        view.addGestureRecognizer(drag)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.handleTap(_:)))
        view.addGestureRecognizer(tap)
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(HomeViewController.handleSwipe(_:)))
        swipe.direction = .Down
        view.addGestureRecognizer(swipe)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
        guard !loaded else {
            return
        }
        loaded = true
        animateAreasIn()
    }
    
    func reloadData() {
        areaViews.forEach({ area in
            area.todos = self.service.loadTodosByType(area.todoType)
        })
    }
    
    func animateAreasIn() {
        func animateAreaViewIn(view: UIView, delay: NSTimeInterval) {
            view.alpha = 0
            view.transform = CGAffineTransformMakeScale(5, 5)
            UIView.animateWithDuration(1, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                view.transform = CGAffineTransformIdentity
                view.alpha = 1
            }, completion: nil)
        }
        var delay: NSTimeInterval = 0
        areaViews.forEach({ area in
            animateAreaViewIn(area, delay: delay)
            delay = delay + 0.12
        })
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}

extension HomeViewController {
    
    func inputButtonPressed(button: UIButton) {
        showInput()
    }
    
    func menuButtonPressed(button: UIButton) {
        goToSettings()
    }
    
    func handleSwipe(gesture: UIGestureRecognizer) {
        guard gesture.state == .Ended else {
            return
        }
        showInput()
    }
    
    func handleTap(gesture: UITapGestureRecognizer) {
        guard gesture.state == .Ended else {
            return
        }
        let location = gesture.locationInView(gesture.view)
        guard let area = areaViews.filter({ area in
            area.frame.contains(location)
        }).first else {
            return
        }
        goToList(area.todoType, todos: area.todos)
    }
    
    func handleDrag(gesture: UILongPressGestureRecognizer) {
        var location = gesture.locationInView(gesture.view)
        location.y = max(0, location.y)
        
        if gesture.state == .Began {
            
            let area = areaViews.filter({ area in
                area.frame.contains(location)
            }).first!
            
            guard let todo = area.todos.first else {
                gesture.enabled = false
                gesture.enabled = true
                return
            }
            todoDragging = todo
            
            snapshotView = area.titleLabel.snapshotViewAfterScreenUpdates(true)
            snapshotView.center = view.convertPoint(area.titleLabel.center, fromView: area.titleLabel.superview)
            area.titleLabel.alpha = 0
            area.todos.removeFirst()
            
            UIView.animateWithDuration(0.2, animations: {
                self.snapshotView.scale = 1.15
                area.setHighlighted(true)
            })
            view.addSubview(snapshotView)
            
            startLocation = location
            startCenter = snapshotView.center
            
        }
        else if gesture.state == .Changed {
            areaViews.forEach({ area in
                let contains = area.frame.contains(location)
                area.setHighlighted(contains)
                UIView.animateWithDuration(0.3, animations: {
                    area.titleLabel.alpha = contains ? 0 : 1
                })
            })
            snapshotView.center.x = location.x - startLocation.x + startCenter.x
            snapshotView.center.y = location.y - startLocation.y + startCenter.y
        }
        else if gesture.state == .Ended {
            
            let area = areaViews.filter({ area in
                area.frame.contains(location)
            }).first!
            
            service.updateTodo({
                self.todoDragging.type = area.todoType.rawValue
            })
            area.todos.insert(todoDragging, atIndex: 0)
            
            UIView.animateWithDuration(
                0.3,
                animations: {
                    area.setHighlighted(false)
                    self.snapshotView.center = self.view.convertPoint(area.titleLabel.center, fromView: area.titleLabel.superview)
                    self.snapshotView.scale = 1
                },
                completion: { finished in
                    area.titleLabel.alpha = 1
                    self.snapshotView.removeFromSuperview()
                    self.snapshotView = nil
                }
            )
        }
    }
}

extension HomeViewController {
    
    func showInput() {
        inputButton.animateToType(FlatButtonType.buttonCloseType)
        let vc = R.storyboard.home.input()!
        vc.presentInViewController(self)
        vc.willDismiss = {
            self.inputButton.animateToType(FlatButtonType.buttonAddType)
            self.reloadData()
        }
    }
    
    func goToList(todoType: Todo.TodoType, todos: [Todo]) {
        let vc = R.storyboard.home.list()!
        vc.todos = todos
        vc.title = todoType.description()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToSettings() {
        let vc = R.storyboard.home.settings()!
        vc.modalTransitionStyle = .FlipHorizontal
        presentViewController(vc, animated: true, completion: nil)
    }
}
