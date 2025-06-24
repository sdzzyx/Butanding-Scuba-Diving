//
//  CustomButton.swift
//  BicolScubaDiving
//
//  Created by Melvin Ballesteros on 6/23/25.
//

import UIKit

class CustomButton: UIButton {
    
    let inactiveTextColor: UIColor = .primaryGrayDisableText
    let activeTextColor: UIColor = .white
    let inactiveBackgroundColor: UIColor = .primaryGrayDisableBackground
    let activeBackgroundColor: UIColor = .primaryOrange
    let font = UIFont.roboto(.bold, size: 18)
    
    override var isHighlighted: Bool {
        didSet {
            // Add subtle scaling or opacity change for press 
            UIView.animate(withDuration: 0.15) {
                self.alpha = self.isHighlighted ? 0.6 : 1.0
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        updateAppearance()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
        updateAppearance()
    }
    
    private func configure() {
        layer.cornerRadius = 8
        titleLabel?.font = font
        isEnabled = false // Default state
    }
    
    override var isEnabled: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    private func updateAppearance() {
        if isEnabled {
            backgroundColor = activeBackgroundColor
            setTitleColor(activeTextColor, for: .normal)
        } else {
            backgroundColor = inactiveBackgroundColor
            setTitleColor(inactiveTextColor, for: .normal)
        }
    }
}
