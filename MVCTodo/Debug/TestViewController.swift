//
//  TestViewController.swift
//  MVCTodo
//
//  Created by Dave DeLong on 10/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    
    @IBOutlet private var container: UIView?
    private let colorContainer = ContainerViewController()

    private let r = ColorViewController(color: .red)
    private let g = ColorViewController(color: .green)
    
    init() {
        super.init(nibName: "TestViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        embedChild(colorContainer, in: container)
    }
    
    @IBAction func red(_ sender: Any) {
        if colorContainer.content == r {
            colorContainer.content = nil
        } else {
            colorContainer.content = r
        }
    }
    
    @IBAction func green(_ sender: Any) {
        if colorContainer.content == g {
            colorContainer.content = nil
        } else {
            colorContainer.content = g
        }
    }

}
