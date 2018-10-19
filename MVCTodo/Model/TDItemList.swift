//
//  TDItemList.swift
//  MVCTodo
//
//  Created by Dave DeLong on 10/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

struct TDItemList: Identifiable, Codable {
    
    let identifier: Identifier<TDItemList>
    let name: String
    let emoji: String
    
    init(identifier: Identifier<TDItemList> = Identifier(), name: String, emoji: String = "📝") {
        self.identifier = identifier
        self.name = name
        self.emoji = emoji
    }
}
