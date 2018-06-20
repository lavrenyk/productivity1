//
//  Items.swift
//  productivity
//
//  Created by MoHapX on 18.05.2018.
//  Copyright © 2018 MoHapX. All rights reserved.
//

import Foundation
import RealmSwift

class Project: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var desc: String = ""
    @objc dynamic var createdDate: Date?
    @objc dynamic var dueDate: Date?
    @objc dynamic var planCount: Int = 1
    @objc dynamic var currentCount: Int = 0
    @objc dynamic var finished: Bool = false
    @objc dynamic var achived: Bool = false
    let tasks = List<Task>()
    let workSessions = List<WorkSession>()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "projects")
}

