//
//  workspaceVC.swift
//  productivity
//
//  Created by MoHapX on 15.05.2018.
//  Copyright © 2018 MoHapX. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class WorkspaceVC: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

//    let pageController = PageViewController()
//    let defaults = UserDefaults.standard
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
//    let realm = try! Realm()
//    
//    var categories: Results<Category>?
//    var todoItems: Results<Item>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
//        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
        
//        if tableView.indexPathForSelectedRow == nil {
//            let item = self.tableView.indexPathsForVisibleRows
//            let selectedRow = UserDataService.instance.selectedCategoryRow
//            self.tableView.selectRow(at: item?[selectedRow], animated: false, scrollPosition: .top)
//            UserDataService.instance.setSelectCategory(category: categories![selectedRow])
//        }
        
    }
    
 
    
    @IBAction func addBtnPressed(_ sender: Any) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Workspace", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
        
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.desc = "No description added yet.."
            
            self.save(category: newCategory)
        }
        
        alert.addTextField { (textFld) in
            textFld.placeholder = "Enter Workspace name.."
            textField = textFld
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Working with the Data
    
    func save(category: Category) {
        
//        do {
//            try realm.write {
//                realm.add(category)
//            }
//        } catch {
//            print("Error to save data, \(error)")
//        }
//        
//        tableView.reloadData()
    }
    
    func loadData() {
      
//        categories = realm.objects(Category.self)
//        tableView.reloadData()
    }
    
    func loadTodoItems() {
    }
}

extension WorkspaceVC: UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return categories?.count ?? 1
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "workspaceCell") as? WorkspaceCell else { return UITableViewCell()}
        cell.delegate = self
        
        cell.workspaceName.text = "Тестовая ячейка!"
        
        return cell
        
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "workspaceCell") as? WorkspaceCell else { return UITableViewCell()}
//
//        cell.configureCell(workspace: (categories?[indexPath.row])!)
//
//        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        UserDataService.instance.setSelectCategory(category: categories![indexPath.row])
//        guard let selectedCategory = UserDataService.instance.selectedCategory else { return }
//
//        if selectedCategory != nil {
//            let todoItems = selectedCategory.items.sorted(byKeyPath: "name", ascending: true)
//            UserDataService.instance.setTodoItems(todoItems: todoItems)
//        }
        
//        let pageViewController = self.parent as! PageViewController
//        pageViewController.goNextPage(fowardTo: 1)
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
    
}


    

























 
