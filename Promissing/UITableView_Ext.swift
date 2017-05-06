//
//  UITableView_Ext.swift
//  Promissing
//
//  Created by hPark_ipl on 2017. 5. 5..
//  Copyright © 2017년 hPark. All rights reserved.
//

import UIKit

extension UITableViewCell: Reusable {}

extension UITableView {
    func register<T: UITableViewCell>(_: T.Type) where T: Reusable, T: NibLoadable {
        let nib = UINib(nibName: T.nibName, bundle: nil)
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T where T: Reusable {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError(":: Unable to dequeue cell with identifier : \(T.reuseIdentifier)")
        }
        return cell
    }
}
