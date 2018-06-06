//
//  UserDataService.swift
//  productivity
//
//  Created by MoHapX on 18.05.2018.
//  Copyright © 2018 MoHapX. All rights reserved.
//

import Foundation
import RealmSwift

class UserDataService {
    
    static let instance = UserDataService()
    let realm = try! Realm()
    
    public private(set) var categoryList: Results<Category>?
    public private(set) var todoItems: Results<Item>?
    public private(set) var selectedCategory: Category?
    public private(set) var selectedItem: Item?
    public private(set) var selectedItemRow: Int = -1
    
    func loadCategoryList() {
        categoryList = realm.objects(Category.self)
    }
    
    func setSelectedCategory(index: Int) {
        selectedCategory = categoryList?[index]
    }
    
    func setSelectedItem(index: Int) {
        selectedItem = todoItems?[index]
    }
    
    func saveItem(item: Item) {
        do {
            try realm.write {
                selectedCategory?.items.append(item)
            }
        } catch {
            print("Error saving category, \(error)")
        }
    }
    
    func saveFinishedTask(task: Task) {
        do {
            try realm.write {
                selectedItem?.tasks.append(task)
            }
            NotificationCenter.default.post(name: NOTIF_TASK_DID_SAVE, object: nil)
        } catch {
            print("Error saving finished task, \(error)")
        }
    }
    
    func loadItems(category: Category) {
        if selectedCategory != nil {
            todoItems = selectedCategory?.items.sorted(byKeyPath: "name", ascending: true)
        }
    }
    

    
    func saveCategory(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category, \(error)")
        }
    }
    
    func updateCategoryList(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categoryList?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(categoryForDeletion)
                    loadCategoryList()
                }
            } catch {
                print("Error to delete category, \(error)")
            }
        }
    }
    
    func getCurrentTodoItemRoundsDone() -> Int {
        
        if selectedItem != nil {
            return (selectedItem?.tasks.count)!
        }
        return 0
    }
    
    func updateTodoItems(at indexPath: IndexPath) {
        if let itemForDeletion = self.todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(itemForDeletion)
                    loadItems(category: selectedCategory!)
                }
            } catch {
                print("Error to delete item, \(error)")
            }
        }
    }
    
    func initialCategoriesSetup() {
        let category1 = Category()
        category1.name = "Work"
        category1.icon = String.fontAwesome(.fa_briefcase)
        category1.createdDate = Date()
        saveCategory(category: category1)
        
        let category2 = Category()
        category2.name = "Home"
        category2.icon = String.fontAwesome(.fa_home)
        category2.createdDate = Date()
        saveCategory(category: category2)
        
        let category3 = Category()
        category3.name = "Learning"
        category3.icon = String.fontAwesome(.fa_leanpub)
        category3.createdDate = Date()
        saveCategory(category: category3)
        
        let category4 = Category()
        category4.name = "Reading"
        category4.icon = String.fontAwesome(.fa_book)
        category4.createdDate = Date()
        saveCategory(category: category4)
    }
}





















