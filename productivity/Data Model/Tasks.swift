//
//  Tasks.swift
//  productivity
//
//  Created by MoHapX on 26.05.2018.
//  Copyright © 2018 MoHapX. All rights reserved.
//

import Foundation
import RealmSwift

class Task: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var createDate: Date?
    @objc dynamic var finishDate: Date?
    @objc dynamic var planCount: Int = 1
    @objc dynamic var archived: Bool = false
    let workSessions = List<WorkSession>()
    var parentTask = LinkingObjects(fromType: Project.self, property: "tasks")
}
