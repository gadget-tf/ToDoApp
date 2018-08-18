//
//  TaskListViewController.swift
//  ToDoApp
//
//  Created by gadget-tf on 2018/08/17.
//  Copyright © 2018年 gadget-tf. All rights reserved.
//

import UIKit

class TaskListViewController: UIViewController {
    
    var dataSource: TaskDataSource!
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = TaskDataSource()
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TaskListCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
        
        let barButton = UIBarButtonItem(
            barButtonSystemItem: .add, target: self, action: #selector(barButtonTapped))
        navigationItem.rightBarButtonItem = barButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataSource.loadData()
        tableView.reloadData()
    }
    
    @objc func barButtonTapped(_ sender: UIBarButtonItem) {
        // タスク作成画面へ画面遷移
        let controller = CreateTaskViewController()
        let navi = UINavigationController(rootViewController: controller)
        present(navi, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TaskListCell
        
        let task = dataSource.data(at: indexPath.row)
        
        cell.task = task
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataSource.delete(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let task = dataSource.data(at: indexPath.row)
        
        // タスク作成画面へ画面遷移
        let controller = CreateTaskViewController()
        controller.taskText = task?.text
        controller.taskDeadline = task?.deadline
        controller.updateIndex = indexPath.row
        let navi = UINavigationController(rootViewController: controller)
        present(navi, animated: true, completion: nil)
    }
}
