//
//  Set.swift
//  MVCTodo
//
//  Created by Dave DeLong on 10/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

extension Set {
    
    func member(_ value: Element) -> Element? {
        if let index = self.firstIndex(of: value) {
            return self[index]
        } else {
            return nil
        }
    }
    
}
