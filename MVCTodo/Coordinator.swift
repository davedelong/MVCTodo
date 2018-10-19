//
//  Coordinator.swift
//  MVCTodo
//
//  Created by Dave DeLong on 10/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import UIKit

protocol Coordinator {
    var primaryViewController: UIViewController { get }
    
    func start()
    func stop()
}
