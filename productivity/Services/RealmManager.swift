//
//  RealmManager.swift
//  productivity
//
//  Created by MoHapX on 23.06.2018.
//  Copyright © 2018 MoHapX. All rights reserved.
//

import Foundation
import RealmSwift

let MY_INSTANCE_ADDRESS = "rsystems-realm-todo.de1a.cloud.realm.io"
let AUTH_URL  = URL(string: "https://\(MY_INSTANCE_ADDRESS)")!
let REALM_URL = URL(string: "realms://\(MY_INSTANCE_ADDRESS)/~/main")!

let REALM_USERNAME = "MoHapX"
let REALM_PASSWORD = "12345"

class RealmManager {
        
    private let username = "MoHapX"
    
    private var user: SyncUser?

    
    
    
   
    
}
