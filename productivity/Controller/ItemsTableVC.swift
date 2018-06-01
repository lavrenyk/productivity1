//
//  ItemsTableVC.swift
//  productivity
//
//  Created by MoHapX on 26.05.2018.
//  Copyright © 2018 MoHapX. All rights reserved.
//

import UIKit
import SwipeCellKit

class ItemsTableVC: SwipeTableViewController {
    
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    var tableWidth: CGFloat = 0
    
    @IBOutlet weak var plusLbl: UILabel!
    @IBOutlet weak var navigation: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        plusLbl.fa_text = .fa_plus
        
        UserDataService.instance.loadItems(category: UserDataService.instance.selectedCategory!)
        
        // Обновляем таблицу при изменении данных
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableData(_:)), name: NOTIF_DATA_DID_CHANGE, object: nil)
        
        tableWidth = tableView.frame.size.width - 20
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame.size.width = tableWidth
    }



    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserDataService.instance.todoItems?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as? ItemCell else {return UITableViewCell()}
        cell.nameLbl.text = UserDataService.instance.todoItems?[indexPath.row].name
        
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else {return nil}
        
        
        let delete = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            UserDataService.instance.updateTodoItems(at: indexPath)
        }
        
        return[delete]
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UserDataService.instance.setSelectedItem(index: indexPath.row)
        NotificationCenter.default.post(name: NOTIF_TODO_ITEM_DID_SELECT, object: nil)

        let revealVC = revealViewController()
        revealVC?.frontViewController.viewWillAppear(true)
        revealVC?.revealToggle(animated: true)
        
    }
    
    
    @IBAction func createItemBtnPressed(_ sender: Any) {
        let addItem = AddItemVC()
        addItem.modalPresentationStyle = .custom
        present(addItem, animated: false, completion: nil)
    }
    
    @objc func updateTableData(_ notif: Notification) {
        UserDataService.instance.loadItems(category: UserDataService.instance.selectedCategory!)
        tableView.reloadData()
    }
    
    

}



















