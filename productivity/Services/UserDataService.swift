//
//  UserDataService.swift
//  productivity
//
//  Created by MoHapX on 18.05.2018.
//  Copyright © 2018 MoHapX. All rights reserved.
//

import Foundation

class UserDataService {
    
    static let instance = UserDataService()
    
    public private(set) var selectedCategory: Category?
    
    func selectCategory(category: Category) {
        self.selectedCategory = category
    }
}
