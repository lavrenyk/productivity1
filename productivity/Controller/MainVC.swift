//
//  MainVC.swift
//  productivity
//
//  Created by MoHapX on 15.05.2018.
//  Copyright © 2018 MoHapX. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent;
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    // Outlets
    @IBOutlet weak var menuBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 10
    }


}


