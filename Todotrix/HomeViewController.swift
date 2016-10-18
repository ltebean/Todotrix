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
        
      
        menuButton = VBFPopFlatButton(frame: CGRect(x: 0, y: 0, width: 22, height: 22), buttonType: FlatButtonType.buttonMenuType, buttonStyle: FlatButtonStyle.buttonPlainStyle, animateToInitialState: false)
        menuButton.lineRadius = 1
        menuButton.addTarget(self, action: #selector(HomeViewController.menuButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
        
        inputButton = VBFPopFlatButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20), buttonType: FlatButtonType.buttonAddType, buttonStyle: FlatButtonStyle.buttonPlainStyle, animateToInitialState: false)
        inputButton.lineRadius = 1
        inputButton.addTarget(self, action: #selector(HomeViewController.inputButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: inputButton)
        
        area1.todoType = .importantAndUrgent
        area2.todoType = .important
        area3.todoType = .urgent
        area4.todoType = .other
        
        areaViews = [area1, area2, area3, area4];
        
        let drag = UILongPressGestureRecognizer(target: self, action: #selector(HomeViewController.handleDrag(_:)))
        drag.minimumPressDuration = 0.3
        view.addGestureRecognizer(drag)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.handleTap(_:)))
        view.addGestureRecognizer(tap)
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(HomeViewController.handleSwipe(_:)))
        swipe.direction = .down
        view.addGestureRecognizer(swipe)

    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        func animateAreaViewIn(_ view: UIView, delay: TimeInterval) {
            view.alpha = 0
            view.transform = CGAffineTransform(scaleX: 5, y: 5)
            UIView.animate(withDuration: 1, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                view.transform = CGAffineTransform.identity
                view.alpha = 1
            }, completion: nil)
        }
        var delay: TimeInterval = 0
        areaViews.forEach({ area in
            animateAreaViewIn(area, delay: delay)
            delay = delay + 0.12
        })
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}

extension HomeViewController {
    
    func inputButtonPressed(_ button: UIButton) {
        showInput()
    }
    
    func menuButtonPressed(_ button: UIButton) {
        goToSettings()
    }
    
    func handleSwipe(_ gesture: UIGestureRecognizer) {
        guard gesture.state == .ended else {
            return
        }
        showInput()
    }
    
    func handleTap(_ gesture: UITapGestureRecognizer) {
        guard gesture.state == .ended else {
            return
        }
        let location = gesture.location(in: gesture.view)
        guard let area = areaViews.filter({ area in
            area.frame.contains(location)
        }).first else {
            return
        }
        goToList(area.todoType, todos: area.todos)
    }
    
    func handleDrag(_ gesture: UILongPressGestureRecognizer) {
        var location = gesture.location(in: gesture.view)
        location.y = max(0, location.y)
        
        if gesture.state == .began {
            
            let area = areaViews.filter({ area in
                area.frame.contains(location)
            }).first!
            
            guard let todo = area.todos.first else {
                gesture.isEnabled = false
                gesture.isEnabled = true
                return
            }
            todoDragging = todo
            
            snapshotView = area.titleLabel.snapshotView(afterScreenUpdates: true)
            snapshotView.center = view.convert(area.titleLabel.center, from: area.titleLabel.superview)
            area.titleLabel.alpha = 0
            area.todos.removeFirst()
            
            UIView.animate(withDuration: 0.2, animations: {
                self.snapshotView.scale = 1.15
                area.setHighlighted(true)
            })
            view.addSubview(snapshotView)
            
            startLocation = location
            startCenter = snapshotView.center
            
        }
        else if gesture.state == .changed {
            areaViews.forEach({ area in
                let contains = area.frame.contains(location)
                area.setHighlighted(contains)
                UIView.animate(withDuration: 0.3, animations: {
                    area.titleLabel.alpha = contains ? 0 : 1
                })
            })
            snapshotView.center.x = location.x - startLocation.x + startCenter.x
            snapshotView.center.y = location.y - startLocation.y + startCenter.y
        }
        else if gesture.state == .ended {
            
            let area = areaViews.filter({ area in
                area.frame.contains(location)
            }).first!
            
            service.updateTodo({
                self.todoDragging.type = area.todoType.rawValue
            })
            area.todos.insert(todoDragging, at: 0)
            
            UIView.animate(
                withDuration: 0.3,
                animations: {
                    area.setHighlighted(false)
                    self.snapshotView.center = self.view.convert(area.titleLabel.center, from: area.titleLabel.superview)
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
        inputButton.animate(to: FlatButtonType.buttonCloseType)
        let vc = R.storyboard.home.input()!
        vc.presentInViewController(self)
        vc.willDismiss = {
            self.inputButton.animate(to: FlatButtonType.buttonAddType)
            self.reloadData()
        }
    }
    
    func goToList(_ todoType: Todo.TodoType, todos: [Todo]) {
        let vc = R.storyboard.home.list()!
        vc.todos = todos
        vc.title = todoType.description()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToSettings() {
        let vc = R.storyboard.home.settings()!
        vc.modalTransitionStyle = .flipHorizontal
        present(vc, animated: true, completion: nil)
    }
}
