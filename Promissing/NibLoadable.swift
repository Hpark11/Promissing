//
//  NibLoadable.swift
//  Promissing
//
//  Created by hPark_ipl on 2017. 5. 5..
//  Copyright © 2017년 hPark. All rights reserved.
//

import UIKit

protocol NibLoadable: class {}

extension NibLoadable where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
}


