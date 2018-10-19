//
//  TDItemListCoordinator.swift
//  MVCTodo
//
//  Created by Dave DeLong on 10/19/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import UIKit

class TDItemListCoordinator: Coordinator, TDStorageObserver {
    
    fileprivate class ItemEntry {
        
        static let dateFormatter: DateFormatter = {
            let df = DateFormatter()
            df.timeStyle = .none
            df.dateStyle = .long
            df.doesRelativeDateFormatting = true
            return df
        }()
        
        static func detailText(for item: TDItem) -> String {
            if let completed = item.completion {
                // completed
                return "Completed \(dateFormatter.string(from: completed))"
            } else if let due = item.due {
                // not completed, has due date
                return "Due \(dateFormatter.string(from: due))"
            } else {
                // not completed, no due date
                return "No due date"
            }
        }
        
        var item: TDItem
        let row: TDItemRowViewController
        
        init(item: TDItem) {
            self.item = item
            row = TDItemRowViewController()
            update(with: item)
        }
        
        func update(with item: TDItem) {
            guard item == self.item else { return }
            self.item = item
            row.name = item.name
            row.completed = item.completion != nil
            row.date = ItemEntry.detailText(for: item)
        }
    }
    
    private var list: TDItemList
    private let router: AppRouter
    private let storage: TDStorage
    
    private let itemList = ListViewController(content: [])
    
    private var observationToken: NSObject?
    private var itemEntries = Array<ItemEntry>()
    private let content = ContainerViewController(content: nil)
    
    var primaryViewController: UIViewController { return content }
    
    init(list: TDItemList, storage: TDStorage, router: AppRouter) {
        self.list = list
        self.storage = storage
        self.router = router
        
        content.navigationItem.title = list.name
        content.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem(_:)))
    }
    
    func start() {
        observationToken = storage.addListObserver(self)
        updateItemEntries()
        
        itemList.listDelegate = self
        
        router.showViewController(primaryViewController)
    }
    
    func stop() {
        if let token = observationToken {
            storage.removeListObserver(token)
            observationToken = nil
        }
        router.hideViewController(primaryViewController)
    }
    
    @IBAction func addItem(_ sender: Any) {
        promptForItem()
    }
    
    private func updateItemEntries() {
        let items = storage.items(in: list).sorted(by: \.due, \.name)
        let oldItemsByIdentifier = itemEntries.keyed(by: \.item.identifier)
        
        let newEntries = items.map { item -> ItemEntry in
            if let existing = oldItemsByIdentifier[item.identifier] {
                existing.update(with: item)
                return existing
            }
            
            return ItemEntry(item: item)
        }
        
        itemEntries = newEntries
        
        if itemEntries.isEmpty {
            itemList.content = []
            
            let message = MessageViewController(text: "Tap the button to create your first to do item", actionTitle: "Create item", actionHandler: { [weak self] in
                self?.promptForItem()
            })
            content.content = message
        } else {
            itemList.content = itemEntries.map { $0.row }
            content.content = itemList
        }
    }
    
    func storage(_ storage: TDStorage, addedItem: TDItem, to list: TDItemList) {
        guard list == self.list else { return }
        updateItemEntries()
    }
    
    func storage(_ storage: TDStorage, updatedItem: TDItem) {
        updateItemEntries()
    }
    
    func storage(_ storage: TDStorage, removedItem: TDItem, from list: TDItemList) {
        guard list == self.list else { return }
        updateItemEntries()
    }
    
    private func promptForItem() {
        let prompt = UIAlertController(title: "Add To Do", message: nil, preferredStyle: .alert)
        
        prompt.addTextField {
            $0.placeholder = "Title"
        }
        prompt.addDatePicker {
            $0.minimumDate = Date()
            $0.datePickerMode = .date
        }
        
        
        prompt.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        let create = UIAlertAction(title: "Create", style: .default, handler: { [weak prompt, weak self] action in
            guard let self = self else { return }
            let tf = prompt?.textFields?[0]
            guard let name = tf?.text else { return }
            guard name.isEmpty == false else { return }
            
            var due: Date? = nil
            if prompt?.textFields?[1].text?.isEmpty == false {
                due = prompt?.datePickers?[1]?.date
            }
            
            let item = TDItem(name: name, due: due)
            self.storage.addItem(item, to: self.list)
        })
        prompt.addAction(create)
        
        router.showViewController(prompt)
        
    }
    
}

extension TDItemListCoordinator: ListViewControllerDelegate {
    
}
