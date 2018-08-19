//
//  CreateTaskViewDelegate.swift
//  ToDoApp
//
//  Created by gadget-tf on 2018/08/18.
//  Copyright © 2018年 gadget-tf. All rights reserved.
//

import UIKit

protocol CreateTaskViewDelegate: class {
    func createView(taskEditting view: CreateTaskView, text: String)
    func createView(deadlineEditting view: CreateTaskView, deadline: Date)
    func createView(saveButtonDidTap view: CreateTaskView)
}

class CreateTaskView: UIView {
    private var taskTextField: UITextField!
    private var datePicker: UIDatePicker!
    private var deadlineTextField: UITextField!
    private var saveButton: UIButton!
    
    weak var delegate: CreateTaskViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        taskTextField = UITextField()
        taskTextField.delegate = self
        taskTextField.tag = 0
        taskTextField.layer.borderWidth = 0.5
        taskTextField.layer.cornerRadius = 10.0
        taskTextField.returnKeyType = .done
        taskTextField.placeholder = " 予定を入れて下さい"
        addSubview(taskTextField)
        
        deadlineTextField = UITextField()
        deadlineTextField.tag = 1
        deadlineTextField.layer.borderWidth = 0.5
        deadlineTextField.layer.cornerRadius = 10.0
        taskTextField.returnKeyType = .done
        deadlineTextField.placeholder = " 締切日を入れて下さい"
        addSubview(deadlineTextField)
        
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        deadlineTextField.inputView = datePicker
        
        saveButton = UIButton()
        saveButton.setTitle("保存する", for: .normal)
        saveButton.setTitleColor(UIColor.black, for: .normal)
        saveButton.layer.borderWidth = 0.5
        saveButton.layer.cornerRadius = 4.0
        saveButton.addTarget(self, action: #selector(saveButtonTapped(_:)), for: .touchUpInside)
        addSubview(saveButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func saveButtonTapped(_ sender: UIButton) {
        delegate?.createView(taskEditting: self, text: taskTextField.text!)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        formatter.locale = Locale(identifier: "ja_JP")
        let date = formatter.date(from: deadlineTextField.text!)!
        delegate?.createView(deadlineEditting: self, deadline: date)
        delegate?.createView(saveButtonDidTap: self)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        let deadlineText = dateFormatter.string(from: sender.date)
        deadlineTextField.text = deadlineText
        delegate?.createView(deadlineEditting: self, deadline: sender.date)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        taskTextField.frame = CGRect(
            x: bounds.origin.x + 30,
            y: bounds.origin.y + 30,
            width: bounds.size.width - 60,
            height: 50)
        
        deadlineTextField.frame = CGRect(
            x: taskTextField.frame.origin.x,
            y: taskTextField.frame.maxY + 30,
            width: taskTextField.frame.size.width,
            height: taskTextField.frame.size.height)
        
        let saveButtonSize = CGSize(width: 100, height: 50)
        saveButton.frame = CGRect(
            x: (bounds.size.width - saveButtonSize.width) / 2,
            y: deadlineTextField.frame.maxY + 20,
            width: saveButtonSize.width,
            height: saveButtonSize.height)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if taskTextField.isFirstResponder {
            taskTextField.resignFirstResponder()
        } else if deadlineTextField.isFirstResponder {
            deadlineTextField.resignFirstResponder()
        }
    }
    
    func setText(_ text: String) {
        taskTextField.text = text
    }
    
    func setDeadline(_ deadline: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        let deadlineText = dateFormatter.string(from: deadline)
        deadlineTextField.text = deadlineText
    }
    
}

extension CreateTaskView: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            if let text = textField.text {
                delegate?.createView(taskEditting: self, text: text)
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            if let text = textField.text {
                delegate?.createView(taskEditting: self, text: text)
            }
        }
    }
}
