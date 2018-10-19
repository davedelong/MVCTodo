//
//  UIViewController.swift
//  MVCTodo
//
//  Created by Dave DeLong on 10/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func embedChild(_ newChild: UIViewController, in container: UIView? = nil) {
        
        // if the view controller is already a child of something else, remove it
        if let oldParent = newChild.parent, oldParent != self {
            newChild.beginAppearanceTransition(false, animated: false)
            newChild.willMove(toParent: nil)
            newChild.removeFromParent()
            
            if newChild.viewIfLoaded?.superview != nil {
                newChild.viewIfLoaded?.removeFromSuperview()
            }
            
            newChild.endAppearanceTransition()
        }
        
        // since .view returns an IUO, by default the type of this is "UIView?"
        // explicitly type the variable because We Know Better™
        var targetContainer: UIView = container ?? view
        if targetContainer.isContainedWithin(view) == false {
            targetContainer = view
        }
        
        // add the view controller as a child
        if newChild.parent != self {
            newChild.beginAppearanceTransition(true, animated: false)
            addChild(newChild)
            newChild.didMove(toParent: self)
            targetContainer.embedSubview(newChild.view)
            newChild.endAppearanceTransition()
        } else {
            // the viewcontroller is already a child
            // make sure it's in the right view
            
            // we don't do the appearance transition stuff here,
            // because the vc is already a child, so *presumably*
            // that transition stuff has already happened
            targetContainer.embedSubview(newChild.view)
        }
    }
    
}

