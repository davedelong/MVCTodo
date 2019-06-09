//
//  UIView.swift
//  MVCTodo
//
//  Created by Dave DeLong on 10/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import UIKit

extension UIView {
    
    func embedSubview(_ subview: UIView) {
        // do nothing if this view is already in the right place
        if subview.superview == self { return }
        
        if subview.superview != nil {
            subview.removeFromSuperview()
        }
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        subview.frame = bounds
        addSubview(subview)
        
        NSLayoutConstraint.activate([
            subview.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: subview.trailingAnchor),
            
            subview.topAnchor.constraint(equalTo: topAnchor),
            bottomAnchor.constraint(equalTo: subview.bottomAnchor)
        ])
    }
    
    func isContainedWithin(_ other: UIView) -> Bool {
        var current: UIView? = self
        while let proposedView = current {
            if proposedView == other { return true }
            current = proposedView.superview
        }
        return false
    }

    func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
}
