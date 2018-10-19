//
//  Collection.swift
//  MVCTodo
//
//  Created by Dave DeLong on 10/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

extension Collection {
    
    func sorted<C: Comparable>(by keyPath: KeyPath<Element, C>) -> Array<Element> {
        return sorted { (left, right) -> Bool in
            let leftComparable = left[keyPath: keyPath]
            let rightComparable = right[keyPath: keyPath]
            return leftComparable < rightComparable
        }
    }
    
    func sorted<C1: Comparable, C2: Comparable>(by keyPath1: KeyPath<Element, C1?>, _ keyPath2: KeyPath<Element, C2>) -> Array<Element> {
        
        return sorted { (left, right) -> Bool in
            
            let l1 = left[keyPath: keyPath1]
            let r1 = right[keyPath: keyPath1]
            
            if l1 != nil && r1 == nil { return true }
            if l1 == nil && r1 != nil { return false }
            if let l = l1, let r = r1 {
                if l < r { return true }
                if l > r { return false }
            }
            
            // either l1 and r1 are both nil
            // or they are equal
            
            let l2 = left[keyPath: keyPath2]
            let r2 = right[keyPath: keyPath2]
            
            return l2 < r2
            
        }
        
    }
    
    func keyed<H: Hashable>(by keyPath: KeyPath<Element, H>) -> Dictionary<H, Element> {
        var d = Dictionary<H, Element>()
        for item in self {
            let key = item[keyPath: keyPath]
            d[key] = item
        }
        return d
    }
    
}
