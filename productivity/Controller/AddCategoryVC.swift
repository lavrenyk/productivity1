//
//  AddCategoryVC.swift
//  productivity
//
//  Created by MoHapX on 25.05.2018.
//  Copyright © 2018 MoHapX. All rights reserved.
//

import UIKit

class AddCategoryVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var descTxt: UITextField!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.layer.cornerRadius = 10.0

    }

    @IBAction func closeBtnPressed(_ sender: Any) {
    }
    
    @IBAction func createBtnPressed(_ sender: Any) {
    }
    
    
}
