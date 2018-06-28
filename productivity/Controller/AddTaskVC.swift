//
//  AddTackVC.swift
//  productivity
//
//  Created by MoHapX on 18.06.2018.
//  Copyright © 2018 MoHapX. All rights reserved.
//

import UIKit

class AddTaskVC: UIViewController {

    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var planCount: UITextField!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var doneBtnPressed: UIButton!
    
    var isEditTask: Bool = false
    var editTaskIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mainView.roundCorners(corners: .allCorners, radius: 5)
        
        taskName.attributedPlaceholder = NSAttributedString(string: "Enter task name", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)])
        planCount.attributedPlaceholder = NSAttributedString(string: "Plan count", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)])
        
        if isEditTask {
            loadEditData()
            doneBtnPressed.setTitle("Save changes", for: .normal)
        }
        
    }

    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func createBtnPressed(_ sender: Any) {
        
        let task = Task()
        task.name = taskName.text!
        task.planCount = Int(planCount.text!)!
        if !isEditTask {
            
            task.createDate = Date()
            UserDataService.instance.saveProjectTask(task: task)
        } else {
            
            task.createDate = UserDataService.instance.selectedProjectTask?.createDate
            UserDataService.instance.saveProjectTaskChanges(task: task)
        }
        
        
        NotificationCenter.default.post(name: NOTIF_DATA_DID_CHANGE, object: nil)
        
        dismiss(animated: false, completion: nil)
    }
    
    func loadEditData() {
        guard let taskData = UserDataService.instance.selectedProject?.tasks[editTaskIndex!] else { return }
        
        self.taskName.text = taskData.name
        self.planCount.text = String(taskData.planCount)
    }
    
}
