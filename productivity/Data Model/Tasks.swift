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
    @objc dynamic var start: Date?
    @objc dynamic var end: Date?
}
