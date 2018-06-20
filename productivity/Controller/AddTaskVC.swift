//
//  AddTackVC.swift
//  productivity
//
//  Created by MoHapX on 18.06.2018.
//  Copyright © 2018 MoHapX. All rights reserved.
//

import UIKit
import ValueStepper

let valueStepper: ValueStepper = {
    let stepper = ValueStepper()
    stepper.tintColor = .white
    stepper.minimumValue = 0
    stepper.maximumValue = 1000
    stepper.stepValue = 100
    return stepper
}()

class AddTaskVC: UIViewController {

    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var planCount: UITextField!
    @IBOutlet weak var mainView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mainView.roundCorners(corners: .allCorners, radius: 5)
        
        taskName.attributedPlaceholder = NSAttributedString(string: "Enter task name", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)])
        planCount.attributedPlaceholder = NSAttributedString(string: "Plan count", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)])
        
    }

    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func createBtnPressed(_ sender: Any) {
        let task = Task()
        task.name = taskName.text!
        task.planCount = Int(planCount.text!)!
        task.createDate = Date()
        
        UserDataService.instance.saveProjectTask(task: task)
        
        NotificationCenter.default.post(name: NOTIF_DATA_DID_CHANGE, object: nil)
        
        dismiss(animated: false, completion: nil)
        
    }
    
}
