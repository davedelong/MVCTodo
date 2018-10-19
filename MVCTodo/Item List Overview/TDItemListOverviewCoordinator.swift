//
//  TDItemListOverviewCoordinator.swift
//  MVCTodo
//
//  Created by Dave DeLong on 10/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import UIKit

class TDItemListOverviewCoordinator: Coordinator {
    
    fileprivate class ListEntry {
        private(set) var list: TDItemList
        let row: TDItemListRowViewController
        
        init(list: TDItemList, count: Int) {
            self.list = list
            row = TDItemListRowViewController(emoji: list.emoji, text: list.name, caption: "\(count)")
        }
        
        func update(with list: TDItemList, count: Int) {
            guard self.list == list else { return }
            self.list = list
            row.emoji = list.emoji
            row.text = list.name
            row.caption = "\(count)"
        }
    }
    
    private let router: AppRouter
    private let storage: TDStorage
    private var observationToken: NSObject?
    
    private var listCoordinator: TDItemListCoordinator?
    
    private let mainList = ListViewController(content: [])
    
    private var entries = Array<ListEntry>()
    
    private let content = ContainerViewController(content: nil)
    var primaryViewController: UIViewController { return content }
    
    
    init(storage: TDStorage, router: AppRouter) {
        self.router = router
        self.storage = storage
        
        content.navigationItem.title = "Lists"
        content.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addList(_:)))
    }
    
    func start() {
        observationToken = storage.addListObserver(self)
        updateListEntries()
        
        mainList.listDelegate = self
        
        router.showViewController(primaryViewController)
    }
    
    func stop() {
        if let token = observationToken {
            storage.removeListObserver(token)
            observationToken = nil
        }
        
        router.hideViewController(primaryViewController)
    }
    
    @IBAction func addList(_ sender: Any) {
        promptForList()
    }
    
    private func updateListEntries() {
        let currentLists = storage.lists.sorted(by: \.name)
        let oldListsByIdentifier = entries.keyed(by: \.list.identifier)
        
        let newEntries = currentLists.map { list -> ListEntry in
            let count = storage.numberOfItems(in: list)
            if let existing = oldListsByIdentifier[list.identifier] {
                existing.update(with: list, count: count)
                return existing
            }
            
            return ListEntry(list: list, count: count)
        }
        
        entries = newEntries
        
        if entries.isEmpty {
            mainList.content = []
            
            let message = MessageViewController(text: "Tap the button to create your first list", actionTitle: "Create list", actionHandler: { [weak self] in
                self?.promptForList()
            })
            content.content = message
        } else {
            mainList.content = entries.map { $0.row }
            content.content = mainList
        }
    }
    
    private func entry(for row: UIViewController) -> ListEntry? {
        return entries.first(where: { $0.row === row })
    }
    
    private func promptForList(existingList: TDItemList? = nil) {
        let title: String
        let action: String
        if existingList == nil {
            title = "Create List"
            action = "Create"
        } else {
            title = "Edit List"
            action = "Save"
        }
        let prompt = UIAlertController(title: title, message: "Enter the name of the list", preferredStyle: .alert)
        
        prompt.addTextField { tf in
            tf.placeholder = "List Name"
            tf.text = existingList?.name
        }
        
        prompt.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        let create = UIAlertAction(title: action, style: .default, handler: { [weak prompt, weak self] action in
            let tf = prompt?.textFields?[0]
            guard let name = tf?.text else { return }
            guard name.isEmpty == false else { return }
            
            let list: TDItemList
            if let e = existingList {
                list = TDItemList(identifier: e.identifier, name: name, emoji: e.emoji)
            } else {
                list = TDItemList(name: name)
            }
            self?.storage.saveList(list)
        })
        prompt.addAction(create)
        router.showViewController(prompt)
    }
    
}

extension TDItemListOverviewCoordinator: ListViewControllerDelegate {
    
    func listViewController(_ list: ListViewController, didSelect item: UIViewController) -> ListSelectionResponse {
        
        if let list = entry(for: item)?.list {
            listCoordinator?.stop()
            listCoordinator = TDItemListCoordinator(list: list, storage: storage, router: router)
            listCoordinator?.start()
        }
        
        return .deselect
    }
    
    func listViewController(_ list: ListViewController, swipeConfigurationFor item: UIViewController) -> UISwipeActionsConfiguration? {
        
        guard let list = entry(for: item)?.list else { return nil }
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completion) in
            self?.storage.deleteList(list)
            completion(true)
        }
        
        let rename = UIContextualAction(style: .normal, title: "Rename") { [weak self] (action, view, completion) in
            self?.promptForList(existingList: list)
            completion(true)
        }
        
        let config = UISwipeActionsConfiguration(actions: [rename, delete])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    
}

extension TDItemListOverviewCoordinator: TDStorageObserver {
    
    func storage(_ storage: TDStorage, addedList: TDItemList) {
        updateListEntries()
    }
    
    func storage(_ storage: TDStorage, updatedList: TDItemList) {
        updateListEntries()
    }
    
    func storage(_ storage: TDStorage, removedList: TDItemList) {
        updateListEntries()
    }
    
    func storage(_ storage: TDStorage, addedItem: TDItem, to list: TDItemList) {
        updateListEntries()
    }
    
    func storage(_ storage: TDStorage, updatedItem: TDItem) {
        updateListEntries()
    }
    
    func storage(_ storage: TDStorage, removedItem: TDItem, from list: TDItemList) {
        updateListEntries()
    }
}
