//
//  WorkspaceCell.swift
//  productivity
//
//  Created by MoHapX on 15.05.2018.
//  Copyright © 2018 MoHapX. All rights reserved.
//

import UIKit

class WorkspaceCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var workspaceName: UILabel!
    @IBOutlet weak var workspaceDesc: UILabel!
    @IBOutlet weak var workspaceBtn: RoundConerButton!
    @IBOutlet weak var selectorImg: RoundConerButton!

    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.selectorImg.isHidden = false
        } else {
            self.selectorImg.isHidden = true
        }
    }
    
//    func configureCell(workspace: Workspace) {
//        self.workspaceName.text = "Обучение"
//        self.workspaceName.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//        self.workspaceDesc.text = "сфера повышения квалификации"
//        self.workspaceDesc.textColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
//        self.workspaceBtn.titleLabel?.text = "О"
//    }
    
    func configureCell(workspace: Category) {
        self.workspaceName.text = workspace.name
        self.workspaceName.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.workspaceDesc.text = workspace.desc
        self.workspaceDesc.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        workspaceBtn.setTitle(String(workspace.name.prefix(1)), for: .normal)
      
    }

}
