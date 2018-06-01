//
//  ItemCell.swift
//  productivity
//
//  Created by MoHapX on 27.05.2018.
//  Copyright © 2018 MoHapX. All rights reserved.
//

import UIKit
import SwipeCellKit

class ItemCell: SwipeTableViewCell {
    
    //Outlets
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var categorySelectedFlag: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            self.categorySelectedFlag.isHidden = false
        } else {
            self.categorySelectedFlag.isHidden = true
        }
    }
    
        
    

}


