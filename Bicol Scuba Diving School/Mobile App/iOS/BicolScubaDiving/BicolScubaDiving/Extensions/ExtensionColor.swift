//
//  ExtensionColor.swift
//  BicolScubaDiving
//
//  Created by Melvin Ballesteros on 6/23/25.
//

import UIKit

extension UIColor {

    convenience init?(hex: String, alpha: CGFloat = 1.0) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.hasPrefix("#") ? String(hexSanitized.dropFirst()) : hexSanitized
        
        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255
        let b = CGFloat(rgb & 0x0000FF) / 255
        
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }

    
    // MARK: - App Theme Color
    static var primaryBlueColor: UIColor {
        return UIColor(hex: "2B5CA7") ?? .systemBlue
    }
    
    static var primaryOrange: UIColor {
        return UIColor(hex: "F9811E") ?? .systemOrange
    }
    
    static var primaryGrayLight: UIColor {
        return UIColor(hex: "EAEAEA") ?? .lightGray
    }
    
    static var primaryGrayTextColor: UIColor {
        return UIColor(hex: "A6A8AA") ?? .darkText
    }
    
    static var primaryLightGrayColor: UIColor {
        return UIColor(hex: "BCBCBC") ?? .darkText
    }
    
    static var primaryGrayDarkTextColor: UIColor {
        return UIColor(hex: "9C9C9C") ?? .darkText
    }
    
    static var primaryGrayDisable: UIColor {
        return UIColor(hex: "F5F5F5") ?? .systemGray
    }
    
    static var primaryGrayDisableText: UIColor {
        return UIColor(hex: "CDCDCD") ?? .systemGray2
    }
    
    static var primaryGrayTextDescription: UIColor {
        return UIColor(hex: "CDCDCD") ?? .systemGray3
    }
    
    static var primaryGrayDisableBackground: UIColor {
        return UIColor(hex: "F8F8F8") ?? .systemGray
    }
}




