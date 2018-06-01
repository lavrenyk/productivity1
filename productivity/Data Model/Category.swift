//
//  Category.swift
//  productivity
//
//  Created by MoHapX on 18.05.2018.
//  Copyright © 2018 MoHapX. All rights reserved.
//

import Foundation
import RealmSwift
import FontAwesomeKit_Swift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var desc: String = ""
    @objc dynamic var createdDate: Date?
    @objc dynamic var icon: String = ""
    let items = List<Item>()
}
