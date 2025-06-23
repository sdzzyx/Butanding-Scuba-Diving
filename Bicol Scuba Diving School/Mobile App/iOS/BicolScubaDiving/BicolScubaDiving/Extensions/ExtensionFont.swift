//
//  ExtensionFont.swift
//  BicolScubaDiving
//
//  Created by Melvin Ballesteros on 6/23/25.
//

import UIKit

extension UIFont {
    enum Roboto: String {
        case regular = "Roboto-Regular"
        case light = "Roboto-Light"
        case medium = "Roboto-Medium"
        case bold = "Roboto-Bold"
    }
    
    static func roboto(_ style: Roboto, size: CGFloat) -> UIFont {
        return UIFont(name: style.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
