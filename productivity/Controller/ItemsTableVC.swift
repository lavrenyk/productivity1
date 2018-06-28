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
            
            let projectData = UserDataService.instance.projects![section]
            let result = projectData.tasks.filter("archived == false").count
            var tasks = 0
            for i in 0..<projectData.tasks.count {
                if !projectData.tasks[i].archived {
                    tasks += 1
                }
            }
            print(result)
            return UserDataService.instance.projects![section].tasks.filter("archived == false").count
        } else {
            return 0
        }
    }
    
    // MARK: - Add header row
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as? HeaderCell else {return UITableViewCell()}
        
        let cellData = UserDataService.instance.projects?[section]
//        let count = Float((cellData?.workSessions.count)!)
//        let planCount = Float((cellData?.planCount)!)
//        let result = Int((count / planCount) * 100)
        
        cell.nameLbl.text = cellData?.name
        cell.showStatBtn.setTitle("\((cellData?.workSessions.count)! * 25)", for: .normal)
        
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
    
    func editTask(index: Int) {
        let addTask = AddTaskVC()
        
        addTask.isEditTask = true
        addTask.editTaskIndex = index
        addTask.modalPresentationStyle = .custom
        present(addTask, animated: false, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as? ItemCell else {return UITableViewCell()}
        
        let cellData = UserDataService.instance.projects?[indexPath.section].tasks.filter("archived == false")[indexPath.row]
        
        cell.nameLbl.text = cellData?.name
        
//        let count = Float((cellData?.workSessions.count)!)
//        let planCount = Float((cellData?.planCount)!)
//        let result = Int((count / planCount) * 100)
        cell.taskStatDataBtn.setTitle("\((cellData?.workSessions.count)! * 25)", for: .normal)
        
        cell.delegate = self
            
        return cell
    }
        
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        if orientation == .left {
            
            guard isSwipeRightEnable else { return nil }
            
            let complete = SwipeAction(style: .default, title: nil) { (action, indexPath) in
                do {
                    try self.realm.write {
                        UserDataService.instance.selectedProject?.tasks[indexPath.row].archived = true
                        UserDataService.instance.selectedProject?.tasks[indexPath.row].finishDate = Date()
                    }
                    tableView.reloadData()
                } catch {
                    print("Error archiving task!")
                }
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

            
            let edit = SwipeAction(style: .default, title: nil) { (action, indexPath) in
//                print(UserDataService.instance.selectedProject?.tasks[indexPath.row].name)
                
//                let editTask = AddTaskVC()
//                editTask.taskName.text = UserDataService.instance.selectedProject?.tasks[indexPath.row].name
                
                UserDataService.instance.setSelectedProjectTask(index: indexPath.row)
                self.editTask(index: indexPath.row)
            }
            
            edit.hidesWhenSelected = true
            edit.backgroundColor = #colorLiteral(red: 0.9139201045, green: 0.6803395152, blue: 0.3184101582, alpha: 1)
            edit.image = UIImage(named: "settings")
            
            
            
            
            return[delete, edit]
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





















