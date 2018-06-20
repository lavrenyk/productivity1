//
//  HeaderCell.swift
//  productivity
//
//  Created by MoHapX on 15.06.2018.
//  Copyright © 2018 MoHapX. All rights reserved.
//

import UIKit

protocol HeaderCellDeligate {
    func toggleSection(header: HeaderCell, section: Int)
    func reloadTable()
    func createTask()
}

class HeaderCell: UITableViewCell {
    var delegate: HeaderCellDeligate?
    var section: Int!


    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var selector: UIView!
    @IBOutlet weak var addItemBtn: UIButton!
    @IBOutlet weak var showStatBtn: UIButton!
    @IBOutlet weak var projectMenu: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHeaderAction)))
       
        // Создаем считываение длительного нажатия на кнопку
        self.addItemBtn.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(showProjectMenu)))
        
    }
    
    @objc func selectHeaderAction(guestureRecognizer: UITapGestureRecognizer) {
        let cell = guestureRecognizer.view as! HeaderCell
        delegate?.toggleSection(header: self, section: cell.section)
    }
    
    @objc func showProjectMenu(guestureRecognizer: UILongPressGestureRecognizer) {
        projectMenu.isHidden = false
        addItemBtn.setImage(UIImage(named: "close1"), for: .normal)
    }

    @IBAction func addItemBtnClicked(_ sender: Any) {
        if projectMenu.isHidden {
            delegate?.createTask()
        } else {
            projectMenu.isHidden = true
            addItemBtn.setImage(UIImage(named: "add-icon"), for: .normal)
        }
    }
    
    @IBAction func deleteProjectBtnPressed(_ sender: Any) {
        UserDataService.instance.deleteProject(at: self.section!)
        delegate?.reloadTable()
    }
    
    
    
    

}
