//
//  WorkingBlocks.swift
//  productivity
//
//  Created by MoHapX on 17.06.2018.
//  Copyright © 2018 MoHapX. All rights reserved.
//

import Foundation
import RealmSwift

class WorkSession: Object {
    @objc dynamic var start: Date?
    @objc dynamic var end: Date?
    var parentProject = LinkingObjects(fromType: Project.self, property: "workSessions")
    var parentTask = LinkingObjects(fromType: Task.self, property: "workSessions")
}
