//
//  UIWindow.swift
//  MVCTodo
//
//  Created by Dave DeLong on 10/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import UIKit

extension UIWindow {
    
    convenience init(rootViewController: UIViewController) {
        self.init(frame: UIScreen.main.bounds)
        self.rootViewController = rootViewController
        self.makeKeyAndVisible()
    }
    
}
