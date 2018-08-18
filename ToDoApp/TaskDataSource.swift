//
//  TaskDataSource.swift
//  ToDoApp
//
//  Created by gadget-tf on 2018/08/17.
//  Copyright © 2018年 gadget-tf. All rights reserved.
//

import Foundation

class TaskDataSource: NSObject {
    private var tasks = [Task]()

    func loadData() {
        tasks.removeAll()
        
        let userDefaults = UserDefaults.standard
        if let archiveData = userDefaults.object(forKey: "tasks") as? Data {
            if let data = NSKeyedUnarchiver.unarchiveObject(with: archiveData) as? [Task] {
                tasks.append(contentsOf: data)
            }
        }
    }
    
    func save(task: Task) {
        loadData()
        
        self.tasks.append(task)
        
        saveUserDefaults()
    }
    
    func delete(at index: Int) {
        loadData()
        
        tasks.remove(at: index)
        
        saveUserDefaults()
    }
    
    func update(at index: Int, task: Task) {
        loadData()
        
        tasks[index].text = task.text
        tasks[index].deadline = task.deadline
        
        saveUserDefaults()
    }
    
    private func saveUserDefaults() {
        let archiveData = NSKeyedArchiver.archivedData(withRootObject: self.tasks)
        let userDefaults = UserDefaults.standard
        userDefaults.set(archiveData, forKey: "tasks")
        userDefaults.synchronize()
    }
    
    func count() -> Int {
        return tasks.count
    }
    
    func data(at index: Int) -> Task? {
        if tasks.count > index {
            return tasks[index]
        }
        return nil
    }
}

