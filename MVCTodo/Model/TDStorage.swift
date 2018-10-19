//
//  TDStorage.swift
//  MVCTodo
//
//  Created by Dave DeLong on 10/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

protocol TDStorageObserver: AnyObject {
    
    func storage(_ storage: TDStorage, addedList: TDItemList)
    func storage(_ storage: TDStorage, updatedList: TDItemList)
    func storage(_ storage: TDStorage, removedList: TDItemList)
    
    func storage(_ storage: TDStorage, addedItem: TDItem, to list: TDItemList)
    func storage(_ storage: TDStorage, updatedItem: TDItem)
    func storage(_ storage: TDStorage, removedItem: TDItem, from list: TDItemList)
    
}

extension TDStorageObserver {
    
    func storage(_ storage: TDStorage, addedList: TDItemList) { }
    func storage(_ storage: TDStorage, updatedList: TDItemList) { }
    func storage(_ storage: TDStorage, removedList: TDItemList) { }
    
    func storage(_ storage: TDStorage, addedItem: TDItem, to list: TDItemList) { }
    func storage(_ storage: TDStorage, updatedItem: TDItem) { }
    func storage(_ storage: TDStorage, removedItem: TDItem, from list: TDItemList) { }
    
}

class TDStorage {
    
    private let location: URL
    private var rawModel: TDStorageModel
    
    private var observers = Dictionary<NSObject, TDStorageObserver>()
    
    init(location: URL) {
        print("Loading from \(location.path)")
        self.location = location
        var raw: TDStorageModel?
        
        if let data = try? Data(contentsOf: location) {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(TDStorageModel.self, from: data) {
                raw = decoded
            }
        }
        
        rawModel = raw ?? TDStorageModel()
    }
    
    private func saveModel() throws {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(rawModel)
            try data.write(to: location)
        } catch let e {
            print("Error saving model: \(e)")
            throw e
        }
    }
    
    private func notify(of: (TDStorageObserver) -> Void) {
        observers.values.forEach { of($0) }
    }
    
    var lists: Array<TDItemList> {
        return Array(rawModel.lists)
    }
    
    func addListObserver(_ observer: TDStorageObserver) -> NSObject {
        let token = NSObject()
        observers[token] = observer
        return token
    }
    
    func removeListObserver(_ token: NSObject) {
        observers.removeValue(forKey: token)
    }
    
    func saveList(_ list: TDItemList) {
        if let existing = rawModel.lists.member(list) {
            // check "existing" against "list" to see if things have actually changed
            if existing.emoji != list.emoji || existing.name != list.name {
                rawModel.lists.remove(existing)
                rawModel.lists.insert(list)
                try? saveModel()
                notify { $0.storage(self, updatedList: list) }
            }
            
        } else {
            rawModel.lists.insert(list)
            try? saveModel()
            notify { $0.storage(self, addedList: list) }
        }
    }
    
    func deleteList(_ list: TDItemList) {
        guard rawModel.lists.contains(list) else { return }
        rawModel.lists.remove(list)
        try? saveModel()
        notify { $0.storage(self, removedList: list) }
    }
    
    func numberOfItems(in list: TDItemList) -> Int {
        return rawModel.associations[list.identifier]?.count ?? 0
    }
    
    func items(in list: TDItemList) -> Set<TDItem> {
        let associations = rawModel.associations[list.identifier] ?? []
        let itemLookup = rawModel.items.keyed(by: \.identifier )
        let items = associations.compactMap { itemLookup[$0] }
        return Set(items)
    }
    
    func addItem(_ item: TDItem, to list: TDItemList) {
        var listItems = rawModel.associations[list.identifier] ?? []
        listItems.insert(item.identifier)
        rawModel.associations[list.identifier] = listItems
        rawModel.items.remove(item)
        rawModel.items.insert(item)
        try? saveModel()
        notify { $0.storage(self, addedItem: item, to: list) }
    }
    
    func updateItem(_ item: TDItem) {
        rawModel.items.remove(item)
        rawModel.items.insert(item)
        try? saveModel()
        notify { $0.storage(self, updatedItem: item) }
    }
    
    func removeItem(_ item: TDItem, from list: TDItemList) {
        var listItems = rawModel.associations[list.identifier] ?? []
        listItems.remove(item.identifier)
        rawModel.associations[list.identifier] = listItems
        try? saveModel()
        notify { $0.storage(self, removedItem: item, from: list) }
    }
    
    
}
