//
//  ListViewController.swift
//  MVCTodo
//
//  Created by Dave DeLong on 10/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import UIKit

struct ListSelectionResponse: OptionSet {
    static let none = ListSelectionResponse(rawValue: 0)
    static let deselect = ListSelectionResponse(rawValue: 1 << 0)
    static let reload = ListSelectionResponse(rawValue: 1 << 1)
    
    let rawValue: Int
    init(rawValue: Int) { self.rawValue = rawValue }
}

protocol ListViewControllerDelegate: AnyObject {
    func listViewController(_ list: ListViewController, didSelect item: UIViewController) -> ListSelectionResponse
    func listViewController(_ list: ListViewController, swipeConfigurationFor item: UIViewController) -> UISwipeActionsConfiguration?
}

extension ListViewControllerDelegate {
    
    func listViewController(_ list: ListViewController, didSelect item: UIViewController) -> ListSelectionResponse {
        return [.deselect]
    }
    
    func listViewController(_ list: ListViewController, swipeConfigurationFor item: UIViewController) -> UISwipeActionsConfiguration? {
        return nil
    }
    
}

class ListViewController: UIViewController {

    var content: Array<UIViewController> {
        didSet { reloadContent(oldContent: oldValue, newContent: content) }
    }
    
    weak var listDelegate: ListViewControllerDelegate?
    
    private let list = UITableViewController(style: .plain)
    private var tableView: UITableView { return list.tableView }
    
    init(content: Array<UIViewController> = []) {
        self.content = content
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        embedChild(list, in: view)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCellDefault.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        reloadContent(oldContent: [], newContent: content)
    }
    
    private func reloadContent(oldContent: Array<UIViewController>, newContent: Array<UIViewController>) {
        let oldSet = Set(oldContent)
        let newSet = Set(newContent)
        
        let removed = oldSet.subtracting(newSet)
        let added = newSet.subtracting(oldSet)
        
        for item in removed {
            item.willMove(toParent: nil)
            item.removeFromParent()
        }
        
        for item in added {
            list.addChild(item)
            item.didMove(toParent: list)
        }
        
        tableView.reloadData()
    }
    
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let row = content[indexPath.row]

        if !cell.contentView.subviews.isEmpty && !row.view.isContainedWithin(cell.contentView) {
            cell.contentView.removeAllSubviews()
        }
        
        cell.contentView.embedSubview(row.view)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = content[indexPath.row]
        
        let response = listDelegate?.listViewController(self, didSelect: row) ?? [.deselect]
        
        if response.contains(.deselect) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        if response.contains(.reload) {
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let row = content[indexPath.row]
        return listDelegate?.listViewController(self, swipeConfigurationFor: row)
        
    }
}
