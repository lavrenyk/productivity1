//
//  CustomView.swift
//  productivity
//
//  Created by MoHapX on 16.05.2018.
//  Copyright © 2018 MoHapX. All rights reserved.
//

import UIKit

@IBDesignable
class CustomView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 2.5 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    override func awakeFromNib() {
        super .awakeFromNib()
        self.setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super .prepareForInterfaceBuilder()
        self.setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = cornerRadius
    }

}
