//
//  Items.swift
//  productivity
//
//  Created by MoHapX on 18.05.2018.
//  Copyright © 2018 MoHapX. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var desc: String = ""
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

