//
//  ActivityCell.swift
//  productivity
//
//  Created by MoHapX on 16.05.2018.
//  Copyright © 2018 MoHapX. All rights reserved.
//

import UIKit
import SwipeCellKit

class ActivityCell: SwipeTableViewCell {

    // Outlets
    @IBOutlet weak var activityNameLbl: UILabel!
    @IBOutlet weak var selectorImg: UIView!
    
    
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
    
    func configureCell(item: Item) {
        activityNameLbl.text = item.name
    }

}
