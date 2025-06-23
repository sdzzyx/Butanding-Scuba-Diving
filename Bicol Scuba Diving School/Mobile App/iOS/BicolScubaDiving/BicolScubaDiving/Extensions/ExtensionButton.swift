//
//  ExtensionButton.swift
//  BicolScubaDiving
//
//  Created by Melvin Ballesteros on 6/23/25.
//

import UIKit

extension UIButton {
    
    func enableTapAnimation(scale: CGFloat = 0.95, duration: TimeInterval = 0.1) {
        addTarget(self, action: #selector(animateDown), for: [.touchDown])
        addTarget(self, action: #selector(animateUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    @objc private func animateDown() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.alpha = 0.8
        }
    }
    
    @objc private func animateUp() {
        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
            self.alpha = 1.0
        }
    }
    
    /// Applies tap animation when using `UIButton.Configuration` (iOS 15+)
    @available(iOS 15.0, *)
    func applyTapEffectWithConfiguration(scale: CGFloat = 0.95, alpha: CGFloat = 0.6, duration: TimeInterval = 0.15) {
        configurationUpdateHandler = { button in
            if button.isHighlighted {
                UIView.animate(withDuration: duration) {
                    button.transform = CGAffineTransform(scaleX: scale, y: scale)
                    button.alpha = alpha
                }
            } else {
                UIView.animate(withDuration: duration) {
                    button.transform = .identity
                    button.alpha = 1.0
                }
            }
        }
    }
}
