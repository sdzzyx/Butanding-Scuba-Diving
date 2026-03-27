//
//  Untitled.swift
//  BicolScubaDiving
//
//  Created by Melvin Ballesteros on 6/23/25.
//
import UIKit

class CustomTextField: UITextField {
    
    var activeBorderColor: UIColor = .primaryBlueColor
    var inactiveBorderColor: UIColor = .primaryGrayLight
    var activeTextColor: UIColor = .primaryBlueColor
    var inactiveTextColor: UIColor = .primaryGrayDisableText
    var activeFont: UIFont = UIFont.roboto(.medium, size: 13)
    var inactiveFont: UIFont = UIFont.roboto(.regular, size: 13)
    var placeholderFont: UIFont = UIFont.roboto(.regular, size: 13)
    var placeholderTextColor: UIColor = .primaryGrayDisableText

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        setupObservers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStyle()
        setupObservers()
    }
    
    private func setupStyle() {
        borderStyle = .none
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = inactiveBorderColor.cgColor
        textColor = inactiveTextColor
        setLeftPadding(12)
    }
    
    private func setupObservers() {
        addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
    }
    
    // MARK: - Behavior
    @objc private func editingDidBegin() {
        layer.borderColor = activeBorderColor.cgColor
        textColor = activeTextColor
        font = activeFont
    }
    
    @objc private func editingDidEnd() {
        layer.borderColor = inactiveBorderColor.cgColor
        textColor = inactiveTextColor
        font = inactiveFont
    }
    
    private func setLeftPadding(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: frame.height))
        leftView = paddingView
        leftViewMode = .always
    }
    
    // MARK: - Public Interface
    func setPlaceholder(_ text: String) {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: placeholderTextColor,
            .font: placeholderFont
        ]
        attributedPlaceholder = NSAttributedString(string: text, attributes: attributes)
    }
}
