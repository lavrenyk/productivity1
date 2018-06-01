//
//  ActivityVC.swift
//  productivity
//
//  Created by MoHapX on 16.05.2018.
//  Copyright © 2018 MoHapX. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class ActivityVC: UIViewController {

    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
//    let realm = try! Realm()
//    var todoItems: Results<Item>?
//
//    var selectedCategory: Category?
//    var rowsNumber: Int = 0
    
//    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        selectedCategory = UserDataService.instance.selectedCategory
//        if selectedCategory != nil {
//            loadItems()
//        } else {
//            print("Category didn't select!")
//        }
//        if UserDataService.instance.selectedItemRow >= 0 && (todoItems?.count)! > 0 {
//            let items = self.tableView.indexPathsForVisibleRows
//            let selectedItem = UserDataService.instance.selectedItemRow
//            self.tableView.selectRow(at: items?[selectedItem], animated: false, scrollPosition: .top)
//        }
    }
    
    //MARK: - Временное добавление категорий
    
    
    //MARK: - Работа с данными
    
    func save(items: Item) {
//        do {
//            try realm.write {
//                realm.add(items)
//            }
//        } catch {
//            print("Can't save Category! \(error)")
//        }
//        tableView.reloadData()
    }
    
    func loadItems() {
//        todoItems = UserDataService.instance.todoItems
//        print(todoItems?.count)
//        tableView.reloadData()
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
        addItem()
    }
    

}

//MARK: - Настройка отображения таблицы
extension ActivityVC: UITableViewDataSource, UITableViewDelegate, SwipeTableViewCellDelegate {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return todoItems?.count ?? 1
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if todoItems != nil {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell") as? ActivityCell else { return UITableViewCell()}
        
        cell.delegate = self
        
            cell.activityNameLbl.text = "Plese select the category"
        
//            cell.configureCell(item: todoItems![indexPath.row])
        
            return cell
//        } else {
//            let cell = UITableViewCell()
//            cell.textLabel?.text = "Please, select a category!"
//            cell.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 0.3)
//            cell.textLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//
//            return cell
//        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let revealVC = revealViewController()
        
//        UserDataService.instance.setSelectedItem(item: todoItems![indexPath.row], itemRow: indexPath.row)
//
//        revealViewController().frontViewController.viewWillAppear(true)
//        revealVC?.revealToggle(animated: true)
    }

    
    func addItem() {
//        var textField = UITextField()
//
//        let alert = UIAlertController(title: "Add Todoey Item", message: "Just add the thing", preferredStyle: .alert)
//        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
//
//            if let currentCategory = self.selectedCategory {
//                do {
//                    try self.realm.write {
//                        let newItem = Item()
//                        newItem.name = textField.text!
//                        currentCategory.items.append(newItem)
//                        print("New Item has created!")
//                    }
//                } catch {
//                    print("Error saving new items, \(error)")
//                }
//            }
//
//            self.tableView.reloadData()
//        }
//        
//        alert.addTextField { (alertTextField) in
//            alertTextField.placeholder =  "Create new Item!"
//            textField = alertTextField
//        }
//        
//        alert.addAction(action)
//        present(alert, animated: true, completion: nil)
    }
}













