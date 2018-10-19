//
//  TDStorageModel.swift
//  MVCTodo
//
//  Created by Dave DeLong on 10/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

struct TDStorageModel: Codable {
    
    var lists: Set<TDItemList>
    var items: Set<TDItem>
    var associations: Dictionary<Identifier<TDItemList>, Set<Identifier<TDItem>>>
    
    init() {
        lists = []
        items = []
        associations = [:]
    }
    
}
