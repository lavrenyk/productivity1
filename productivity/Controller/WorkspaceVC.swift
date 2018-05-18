//
//  workspaceVC.swift
//  productivity
//
//  Created by MoHapX on 15.05.2018.
//  Copyright © 2018 MoHapX. All rights reserved.
//

import UIKit
import RealmSwift

class WorkspaceVC: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if tableView.indexPathForSelectedRow == nil {
            let item = self.tableView.indexPathsForVisibleRows
            self.tableView.selectRow(at: item?[0], animated: false, scrollPosition: .top)
            UserDataService.instance.selectCategory(category: categories![0])
            print(item)
        }
        
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
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error to save data, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadData() {
      
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
}

extension WorkspaceVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "workspaceCell") as? WorkspaceCell else { return UITableViewCell()}
        
        cell.configureCell(workspace: (categories?[indexPath.row])!)
        
        return cell
    }
    
    
    
}


    

























 
