//
//  AddItemVC.swift
//  productivity
//
//  Created by MoHapX on 27.05.2018.
//  Copyright © 2018 MoHapX. All rights reserved.
//

import UIKit

class AddProjectVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var itemNameTxt: UITextField!
    @IBOutlet weak var itemDescTxt: UITextField!
    @IBOutlet weak var itemPlanCountTxt: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        setupView()
    }

    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func createItemBtnPressed(_ sender: Any) {
        guard let projectName = itemNameTxt.text, itemNameTxt.text != "" else {return}
        guard let planCount = itemPlanCountTxt.text, itemPlanCountTxt.text != "" else {return}
        
        let project = Project()
        project.name = projectName
        if itemDescTxt.text != nil {
            project.desc = itemDescTxt.text!
        }
        
        project.planCount = Int(planCount) ?? 1
        project.createdDate = Date()
        
        UserDataService.instance.saveProject(project: project)
        
        NotificationCenter.default.post(name: NOTIF_DATA_DID_CHANGE, object: nil)
        
        dismiss(animated: false, completion: nil)
    }
    
    func setupView() {
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(closeBtnPressed(_:)))
        
        mainView.layer.cornerRadius = 10

    }
}





















