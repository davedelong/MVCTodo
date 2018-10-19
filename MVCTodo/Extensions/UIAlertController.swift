//
//  UIAlertController.swift
//  MVCTodo
//
//  Created by Dave DeLong on 10/19/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import UIKit

private var DatePickerHelperKey: UInt8 = 0

extension UIAlertController {
    
    func addDatePicker(_ configuration: @escaping (UIDatePicker) -> Void) {
        addTextField { tf in
            
            let dp = UIDatePicker()
            configuration(dp)
            tf.inputView = dp
            
            let helper = AlertDatePickerHelper(textField: tf, datePicker: dp)
            objc_setAssociatedObject(tf, &DatePickerHelperKey, helper, .OBJC_ASSOCIATION_RETAIN)
        }
        
    }
    
    var datePickers: Array<UIDatePicker?>? {
        guard let fields = textFields else { return nil }
        return fields.map { $0.inputView as? UIDatePicker }
    }
    
}

class AlertDatePickerHelper: NSObject {
    
    weak var textField: UITextField?
    let formatter: DateFormatter
    
    init(textField: UITextField, datePicker: UIDatePicker) {
        self.textField = textField
        formatter = DateFormatter()
        
        super.init()
        
        switch datePicker.datePickerMode {
            case .date:
                formatter.dateStyle = .long
                formatter.timeStyle = .none
            case .dateAndTime:
                formatter.dateStyle = .long
                formatter.timeStyle = .long
            case .time:
                formatter.dateStyle = .none
                formatter.timeStyle = .long
            default:
                fatalError("Unsupported date picker mode")
        }
        
        datePicker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
    }
    
    @objc func datePickerChanged(_ datePicker: UIDatePicker) {
        let date = datePicker.date
        let string = formatter.string(from: date)
        textField?.text = string
    }
    
}

