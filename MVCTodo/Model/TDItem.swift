//
//  TDItem.swift
//  MVCTodo
//
//  Created by Dave DeLong on 10/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

struct TDItem: Identifiable, Codable {
    let identifier: Identifier<TDItem>
    
    let name: String
    let creation: Date
    
    let due: Date?
    let completion: Date?
    
    init(identifier: Identifier<TDItem> = Identifier(), name: String, creation: Date = Date(), due: Date? = nil, completion: Date? = nil) {
        
        self.identifier = identifier
        self.name = name
        self.creation = creation
        self.due = due
        self.completion = completion
        
    }
}
