//
//  ContainerViewController.swift
//  MVCTodo
//
//  Created by Dave DeLong on 10/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    var content: UIViewController? {
        didSet {
            replaceChild(oldValue, with: content)
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    init(content: UIViewController?) {
        self.content = content
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init() {
        self.init(content: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func loadView() {
        view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = true
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replaceChild(nil, with: content)
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return content
    }
    
    private func replaceChild(_ oldChild: UIViewController?,
                             with newChild: UIViewController?) {
        
        let duration: TimeInterval
        let options: UIView.AnimationOptions
        
        if viewIfLoaded?.window == nil {
            duration = 0
            options = []
        } else {
            duration = 0.3
            options = .transitionCrossDissolve
        }
        
        switch (oldChild, newChild) {
            case (let o?, let n?):
                transition(from: o, to: n, in: view, duration: duration, options: options)
            case (nil, let n?):
                transition(to: n, in: view, duration: duration, options: options)
            case (let o?, nil):
                transition(from: o, in: view, duration: duration, options: options)
            case (nil, nil):
                return
        }
    }
    
    private func transition(to: UIViewController, in container: UIView, duration: TimeInterval, options: UIView.AnimationOptions) {
        
        // embed the "to" view
        // animate it in
        
        to.beginAppearanceTransition(true, animated: true)
        addChild(to)
        to.view.alpha = 0
        container.embedSubview(to.view)
        
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            to.view.alpha = 1
        }, completion: { _ in
            to.didMove(toParent: self)
            to.endAppearanceTransition()
        })
    }
    
    private func transition(from: UIViewController, in container: UIView, duration: TimeInterval, options: UIView.AnimationOptions) {
        
        // animate out the "from" view
        // remove it
        
        from.beginAppearanceTransition(false, animated: true)
        from.willMove(toParent: nil)
        UIView.animate(withDuration: duration, animations: {
            from.view.alpha = 0
        }, completion: { _ in
            from.view.removeFromSuperview()
            from.endAppearanceTransition()
            from.removeFromParent()
        })
    }
    
    private func transition(from: UIViewController, to: UIViewController, in container: UIView, duration: TimeInterval, options: UIView.AnimationOptions) {
        
        if from == to { return }
        
        // animate from "from" view to "to" view
        
        from.beginAppearanceTransition(false, animated: true)
        to.beginAppearanceTransition(true, animated: true)
        
        from.willMove(toParent: nil)
        addChild(to)
        
        to.view.alpha = 0
        from.view.alpha = 1
        
        container.embedSubview(to.view)
        container.bringSubviewToFront(from.view)
        
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: {
            to.view.alpha = 1
            from.view.alpha = 0
        }, completion: { _ in
            
            from.view.removeFromSuperview()
            
            from.endAppearanceTransition()
            to.endAppearanceTransition()
            
            from.removeFromParent()
            to.didMove(toParent: self)
            
        })
        
    }
    
}
