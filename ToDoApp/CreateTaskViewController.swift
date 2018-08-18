//
//  CreateTaskViewController.swift
//  ToDoApp
//
//  Created by gadget-tf on 2018/08/17.
//  Copyright © 2018年 gadget-tf. All rights reserved.
//

import UIKit

class CreateTaskViewController: UIViewController {
    
    fileprivate var createTaskView: CreateTaskView!
    
    fileprivate var dataSource: TaskDataSource!
    var taskText: String?
    var taskDeadline: Date?
    var updateIndex: Int = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        createTaskView = CreateTaskView()
        createTaskView.delegate = self
        view.addSubview(createTaskView)
        
        if let text = taskText {
            createTaskView.setText(text)
        }
        if let deadline = taskDeadline {
            createTaskView.setDeadline(deadline)
        }
        
        dataSource = TaskDataSource()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        createTaskView.frame = CGRect(
            x: view.safeAreaInsets.left,
            y: view.safeAreaInsets.top,
            width: view.frame.size.width - view.safeAreaInsets.left - view.safeAreaInsets.right,
            height: view.frame.size.height - view.safeAreaInsets.bottom)
        
        let barButton = UIBarButtonItem(
            title: "戻る", style: .done, target: self, action: #selector(barButtonTapped(_:)))
        navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func barButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func showSaveAlert() {
        let alertController = UIAlertController(title: "保存しました", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel) { (action: UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
            //_ = self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func showUpdateAlert() {
        let alertController = UIAlertController(title: "更新しました", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .cancel) { (action: UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
            //_ = self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func showMissingTaskTextAlert() {
        let alertController = UIAlertController(title: "タスクを入力して下さい", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func showMissingDeadlineAlert() {
        let alertController = UIAlertController(title: "締切日を入力して下さい", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension CreateTaskViewController: CreateTaskViewDelegate {
    func createView(taskEditting view: CreateTaskView, text: String) {
        taskText = text
    }
    
    func createView(deadlineEditting view: CreateTaskView, deadline: Date) {
        taskDeadline = deadline
    }
    
    func createView(saveButtonDidTap view: CreateTaskView) {
        guard let taskText = taskText else {
            showMissingTaskTextAlert()
            return
        }
        guard let taskDeadline = taskDeadline else {
            showMissingDeadlineAlert()
            return
        }
        let task = Task(text: taskText, deadline: taskDeadline)
        
        if updateIndex >= 0 {
            dataSource.update(at: updateIndex, task: task)
            
            showUpdateAlert()
        } else {
            dataSource.save(task: task)
            
            showSaveAlert()
        }
    }
    
    
}
