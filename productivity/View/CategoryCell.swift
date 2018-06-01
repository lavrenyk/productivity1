//
//  CategoryCellTableViewCell.swift
//  productivity
//
//  Created by MoHapX on 21.05.2018.
//  Copyright © 2018 MoHapX. All rights reserved.
//

import UIKit
import SwipeCellKit

class CategoryCell: SwipeTableViewCell {

    // Outlets
    @IBOutlet weak var rounedCornerView: UIView!
    @IBOutlet weak var labelIcon: UILabel!
    @IBOutlet weak var categoryTitleLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        rounedCornerView.roundCorners(corners: [.bottomLeft, .topLeft], radius: 7)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
