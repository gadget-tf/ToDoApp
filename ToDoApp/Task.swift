//
//  Task.swift
//  ToDoApp
//
//  Created by gadget-tf on 2018/08/17.
//  Copyright © 2018年 gadget-tf. All rights reserved.
//

import Foundation

class Task: NSObject, NSCoding {
    var text: String = ""
    var deadline: Date = Date()
    
    override init() {
    }
    
    init(text: String, deadline: Date) {
        self.text = text
        self.deadline = deadline
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.text, forKey: "text")
        aCoder.encode(self.deadline, forKey: "deadline")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.text = aDecoder.decodeObject(forKey: "text") as! String
        self.deadline = aDecoder.decodeObject(forKey: "deadline") as! Date
    }
}
