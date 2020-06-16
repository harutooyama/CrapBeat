//
//  Todo.swift
//  TodoApp
//
//  Created by Owner on 2020/06/15.
//  Copyright © 2020 Owner. All rights reserved.
//

import Foundation
import RealmSwift

class Todo: Object{

    @objc dynamic var name = ""

    @objc dynamic var desc = ""

    @objc dynamic var isComplete = false

    @objc dynamic var createDate = NSDate(timeIntervalSince1970: 0)

    @objc dynamic var updateDate = NSDate(timeIntervalSince1970: 0)
}

