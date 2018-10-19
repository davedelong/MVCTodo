//
//  TDItemListRowViewController.swift
//  MVCTodo
//
//  Created by Dave DeLong on 10/18/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import UIKit

class TDItemListRowViewController: UIViewController {
    
    @IBOutlet private var emojiLabel: UILabel?
    @IBOutlet private var textLabel: UILabel?
    @IBOutlet private var captionLabel: UILabel?
    
    init(emoji: String = "", text: String, caption: String) {
        self.emoji = emoji
        self.text = text
        self.caption = caption
        super.init(nibName: "TDItemListRowViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var emoji: String {
        didSet {
            emojiLabel?.text = emoji.first.map { String($0) } ?? "📝"
        }
    }
    
    var text: String {
        didSet { textLabel?.text = text }
    }
    
    var caption: String {
        didSet { captionLabel?.text = caption }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        emojiLabel?.text = emoji.first.map { String($0) } ?? "📝"
        textLabel?.text = text
        captionLabel?.text = caption
    }

}
