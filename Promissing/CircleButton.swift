//
//  CircleButton.swift
//  Promissing
//
//  Created by hPark_ipl on 2017. 5. 6..
//  Copyright © 2017년 hPark. All rights reserved.
//

import UIKit

@IBDesignable
class CircleButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 48.0 {
        didSet {
            setupView()
        }
    }
    
    override func prepareForInterfaceBuilder() {
        setupView()
    }
    
    func setupView() {
        layer.cornerRadius = cornerRadius
    }
}
