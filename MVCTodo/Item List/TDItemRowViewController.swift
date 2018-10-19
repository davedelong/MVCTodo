//
//  TDItemRowViewController.swift
//  MVCTodo
//
//  Created by Dave DeLong on 10/19/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import UIKit

class TDItemRowViewController: UIViewController {
    
    @IBOutlet private var nameLabel: UILabel?
    @IBOutlet private var dateLabel: UILabel?
    @IBOutlet private var statusLabel: UILabel?
    
    var name: String = "" {
        didSet { nameLabel?.text = name }
    }
    
    var date: String = "" {
        didSet { dateLabel?.text = date }
    }
    
    var completed: Bool = false {
        didSet { statusLabel?.text = completed ? "✅" : "⭕️" }
    }
    
    init() {
        super.init(nibName: "TDItemRowViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameLabel?.text = name
        dateLabel?.text = date
        statusLabel?.text = completed ? "✅" : "⭕️"
    }

}
