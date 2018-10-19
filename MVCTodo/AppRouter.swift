//
//  AppRouter.swift
//  MVCTodo
//
//  Created by Dave DeLong on 10/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import UIKit

class AppRouter: NSObject {
    
    var rootViewController: UIViewController {
        guard let first = navigationStack.first else {
            fatalError("There must always be at least one navigation controller")
        }
        return first
    }
    
    private var navigationStack: Array<UINavigationController>
    private var currentNavigationController: UINavigationController {
        guard let top = navigationStack.last else {
            fatalError("There must always be a navigation controller on the stack")
        }
        return top
    }
    
    override init() {
        navigationStack = [UINavigationController(navigationBarClass: nil, toolbarClass: nil)]
        super.init()
    }
    
    func showViewController(_ vc: UIViewController) {
        let current = currentNavigationController
        
        if vc is UIAlertController {
            current.present(vc, animated: true, completion: nil)
        } else {
            let animated = current.children.isEmpty == false
            current.pushViewController(vc, animated: animated)
        }
    }
    
    func hideViewController(_ vc: UIViewController) {
        let current = currentNavigationController
        let stack = current.children
        if let index = stack.index(of: vc) {
            let newStack = Array(stack[0..<index])
            currentNavigationController.setViewControllers(newStack, animated: true)
        }
    }
    
}
