//
//  ItemsTableVC.swift
//  productivity
//
//  Created by MoHapX on 26.05.2018.
//  Copyright © 2018 MoHapX. All rights reserved.
//

import UIKit
import SwipeCellKit
import RealmSwift

class ItemsTableVC: SwipeTableViewController, HeaderCellDeligate {
    
    var notificationTocken: NotificationToken? = nil
    
    var tableWidth: CGFloat = 0
    var expandedSection = -1
    let isSwipeRightEnable = true
    
    let realm = try! Realm()

    @IBOutlet weak var plusLbl: UILabel!
    @IBOutlet weak var navigation: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        plusLbl.text = "+"
        
        UserDataService.instance.loadProjects(category: UserDataService.instance.selectedCategory!)
        
        // Обновляем таблицу при изменении данных
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableData(_:)), name: NOTIF_DATA_DID_CHANGE, object: nil)
        
        tableWidth = tableView.frame.size.width - 20
        
        tableView.estimatedRowHeight = 41
        
        notificationTocken = realm.observe { (notification, realm) in
//            UserDataService.instance.loadProjects(category: User)
        }

        
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame.size.width = tableWidth
        
    }



    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return UserDataService.instance.projects?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 51
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if expandedSection == section {
            print(UserDataService.instance.projects![section].tasks.count)
            return UserDataService.instance.projects![section].tasks.count
        } else {
            return 0
        }
    }
    
    // MARK: - Add header row
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as? HeaderCell else {return UITableViewCell()}
        
        let cellData = UserDataService.instance.projects?[section]
        let count = Float((cellData?.workSessions.count)!)
        let planCount = Float((cellData?.planCount)!)
        let result = Int((count / planCount) * 100)
        
        cell.nameLbl.text = cellData?.name
        cell.showStatBtn.setTitle("\(result)%", for: .normal)
        
        if expandedSection == section {
            cell.nameLbl.font = UIFont(name: "RobotoCondensed-Regular", size: 20)
            cell.selector.isHidden = false
            cell.addItemBtn.isHidden = false
            cell.showStatBtn.isHidden = true
        } else {
            cell.nameLbl.font = UIFont(name: "RobotoCondensed-Light", size: 18)
        }
        cell.section = section
        cell.delegate = self
        
        return cell
    }
    
    func toggleSection(header: HeaderCell, section: Int) {
        if expandedSection == section {
            expandedSection = -1
        } else {
            expandedSection = section
        }
        
        UserDataService.instance.setSelectedProject(index: section)
        
        tableView.reloadData()
    }
    
    func reloadTable() {
        tableView.reloadData()
    }
    
    func createTask() {
        let addTask = AddTaskVC()
        addTask.modalPresentationStyle = .custom
        present(addTask, animated: false, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as? ItemCell else {return UITableViewCell()}
        
        let cellData = UserDataService.instance.projects?[indexPath.section].tasks[indexPath.row]
        
        cell.nameLbl.text = cellData?.name
        
        let count = Float((cellData?.workSessions.count)!)
        let planCount = Float((cellData?.planCount)!)
        let result = Int((count / planCount) * 100)
        cell.taskStatDataBtn.setTitle("\(result)%", for: .normal)
        
        cell.delegate = self
            
        return cell
    }
        
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        if orientation == .left {
            
            guard isSwipeRightEnable else { return nil }
            
            let complete = SwipeAction(style: .default, title: nil) { (action, indexPath) in
                print("Check task comleted!")
            }
            
            complete.hidesWhenSelected = true
            complete.backgroundColor = #colorLiteral(red: 0.262745098, green: 0.6274509804, blue: 0, alpha: 1)
            complete.image = UIImage(named: "complete")
            
            return [complete]
           
        } else {
                
            let delete = SwipeAction(style: .destructive, title: nil) { (action, indexPath) in
                UserDataService.instance.deleteTask(at: indexPath)
                action.fulfill(with: .delete)
                
                tableView.reloadData()
            }
            
            delete.image = UIImage(named: "trash")
            
            
            return[delete]
        }
        
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = orientation == .left ? .selection : .destructive
        return options
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UserDataService.instance.setSelectedProject(index: indexPath.section)
        UserDataService.instance.setSelectedProjectTask(index: indexPath.row)
        
        NotificationCenter.default.post(name: NOTIF_TODO_ITEM_DID_SELECT, object: nil)

        let revealVC = revealViewController()
        revealVC?.frontViewController.viewWillAppear(true)
        revealVC?.revealToggle(animated: true)
        
    }
    
    
    @IBAction func createItemBtnPressed(_ sender: Any) {
        let addItem = AddProjectVC()
        addItem.modalPresentationStyle = .custom
        present(addItem, animated: false, completion: nil)
    }
    
    @objc func updateTableData(_ notif: Notification) {
        UserDataService.instance.loadProjects(category: UserDataService.instance.selectedCategory!)
        tableView.reloadData()
    }
    
    
    
}





















