//
//  RoundedImageView.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 10/12/25.
//

import UIKit

class RoundedImageView: UIImageView {
    var cornerRadiusValue: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadiusValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if cornerRadiusValue == 0 {
            layer.cornerRadius = bounds.width / 2 // Default to circle
        }
    }
}
