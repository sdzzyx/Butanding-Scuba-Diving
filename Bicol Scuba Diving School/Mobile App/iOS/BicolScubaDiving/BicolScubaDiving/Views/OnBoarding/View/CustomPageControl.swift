//
//  CustomPageControl.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 6/18/25.
//

import UIKit

class CustomPageControl: UIView {

    // MARK: - Public Properties
    var numberOfPages: Int = 0 {
        didSet {
            setupIndicators() // Will Recreate indicator views
        }
    }
    
    var currentPage: Int = 0 {
        didSet {
            updateIndicators() // Will Update appearance of existing indicators
        }
    }
    
    var pageIndicatorTintColor: UIColor = .white { // Inactive: White fill
        didSet {
            updateIndicators()
        }
    }
    
    var currentPageIndicatorTintColor: UIColor = .orange { // Active: Orange fill
        didSet {
            updateIndicators()
        }
    }
    
    var indicatorSpacing: CGFloat = 8 // Space between indicators
    
    var indicatorSize: CGFloat = 10 // Size (width and height) for all indicators
    var cornerRadius: CGFloat { // Half of size for perfect circle
        return indicatorSize / 2
    }
    
    var indicatorBorderColor: UIColor = .black // Border color for inactive
    var indicatorBorderWidth: CGFloat = 1.0     // Border width for inactive
    
    // MARK: - Private Properties
    private var indicatorViews: [UIView] = []
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        // Ensure indicators are laid out correctly when view size changes
        updateIndicatorLayout()
    }
    
    // MARK: - Indicator Management
    private func setupIndicators() {
        // Clear existing indicator views
        indicatorViews.forEach { $0.removeFromSuperview() }
        indicatorViews.removeAll()
        
        for _ in 0..<numberOfPages {
            let indicator = UIView()
            indicator.translatesAutoresizingMaskIntoConstraints = false
            indicator.layer.cornerRadius = cornerRadius // Ensure cornerRadius is applied here
            addSubview(indicator)
            indicatorViews.append(indicator)
        }
        updateIndicators() // Set initial colors and sizes
        updateIndicatorLayout() // Position them
    }
    
    private func updateIndicators() {
        for (index, indicator) in indicatorViews.enumerated() {
            if index == currentPage {
                indicator.backgroundColor = currentPageIndicatorTintColor // Orange fill
                indicator.layer.borderColor = nil // No border for the active (orange) indicator
                indicator.layer.borderWidth = 0   // No border for the active (orange) indicator
            } else {
                indicator.backgroundColor = pageIndicatorTintColor // White fill
                indicator.layer.borderColor = indicatorBorderColor.cgColor // Black border
                indicator.layer.borderWidth = indicatorBorderWidth // 1.0pt border
            }
        }
    }
    
    private func updateIndicatorLayout() {
        var currentX: CGFloat = 0
        let centerY = bounds.height / 2
        
        // Calculate the total width needed for all indicators + spacing
        let totalWidth = CGFloat(numberOfPages) * indicatorSize + CGFloat(numberOfPages - 1) * indicatorSpacing
        currentX = (bounds.width - totalWidth) / 2 
        
        for (_, indicator) in indicatorViews.enumerated() {
            let width = indicatorSize
            let height = indicatorSize
            
            indicator.frame = CGRect(x: currentX, y: centerY - (height / 2), width: width, height: height)
            
            currentX += (width + indicatorSpacing)
        }
    }
    
    // MARK: - Intrinsic Content Size
    override var intrinsicContentSize: CGSize {
        guard numberOfPages > 0 else { return .zero }
        
        // Calculate the total width needed for all indicators + spacing
        let totalWidth = CGFloat(numberOfPages) * indicatorSize + CGFloat(numberOfPages - 1) * indicatorSpacing
        
        return CGSize(width: totalWidth, height: indicatorSize) // Height is also indicatorSize
    }
}
