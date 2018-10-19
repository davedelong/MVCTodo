//
//  Identifier.swift
//  MVCTodo
//
//  Created by Dave DeLong on 10/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

struct Identifier<T>: Hashable, Codable {
    static func ==(lhs: Identifier<T>, rhs: Identifier<T>) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    let rawValue: String
    var hashValue: Int { return rawValue.hashValue }
    
    init(_ rawValue: String = UUID().uuidString) { self.rawValue = rawValue }
    init(rawValue: String) { self.rawValue = rawValue }
}

protocol Identifiable: Hashable {
    var identifier: Identifier<Self> { get }
}

extension Identifiable {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var hashValue: Int { return identifier.hashValue }
}
