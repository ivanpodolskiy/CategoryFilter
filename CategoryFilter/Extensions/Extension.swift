//
//  Extension.swift
//  FilterCategories
//
//  Created by user on 30.08.2023.
//

import UIKit

protocol ReusableView: AnyObject {
    static var indentifier: String { get }
}
extension UIColor {
    static var basic: UIColor {
        return UIColor(red: 142 / 255.0,  green: 145 / 255.0, blue: 245 / 255.0, alpha: 1.0)
    }
    static var selected: UIColor {
        return UIColor(red: 161 / 255.0, green: 225 / 255.0, blue: 136 / 255.0, alpha: 1.0)
    }
    static var notSelected: UIColor {
        return UIColor.white
    }
}

