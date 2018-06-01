//
//  AddItemVC.swift
//  productivity
//
//  Created by MoHapX on 27.05.2018.
//  Copyright © 2018 MoHapX. All rights reserved.
//

import UIKit

class AddItemVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var bgView: UIView!
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
        guard let itemName = itemNameTxt.text, itemNameTxt.text != "" else {return}
        guard let planCount = itemPlanCountTxt.text, itemPlanCountTxt.text != "" else {return}
        
        let item = Item()
        item.name = itemName
        if itemDescTxt.text != nil {
            item.desc = itemDescTxt.text!
        }
        
        item.planCount = Int(planCount) ?? 1
        item.createdDate = Date()
        
        UserDataService.instance.saveItem(item: item)
        
        NotificationCenter.default.post(name: NOTIF_DATA_DID_CHANGE, object: nil)
        
        dismiss(animated: false, completion: nil)
    }
    
    func setupView() {
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(closeBtnPressed(_:)))
        bgView.addGestureRecognizer(closeTouch)
        
        mainView.layer.cornerRadius = 10

    }
}





















