//
//  ScrollingContentViewController.swift
//  MVCTodo
//
//  Created by Dave DeLong on 10/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import UIKit

class ScrollingContentViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let scrollViewContentContainer = UIView()

    private let scrollViewContent: UIViewController
    
    init(content: UIViewController) {
        scrollViewContent = content
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.preservesSuperviewLayoutMargins = true
        
        view.embedSubview(scrollView)
        
        scrollView.embedSubview(scrollViewContentContainer)
        scrollView.widthAnchor.constraint(equalTo: scrollViewContentContainer.widthAnchor).isActive = true
        
        embedChild(scrollViewContent, in: scrollViewContentContainer)
        
    }

}
