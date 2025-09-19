//
//  CompanionCardView.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 9/15/25.
//

import UIKit
import SnapKit

class CompanionCardView: UIView {
    
    private let headerButton = UIButton(type: .system)
    private let contentStack = UIStackView()
    private var isExpanded = false
    
    var onUploadCertificateTapped: (() -> Void)?
    
    init(index: Int) {
        super.init(frame: .zero)
        setupUI(index: index)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(index: Int) {

        headerButton.setTitle(AppConstant.Booking.companionTitlePlaceholder + " \(index)", for: .normal)
        headerButton.titleLabel?.font = .roboto(.bold, size: 15)
        headerButton.setTitleColor(.primaryBlueColor, for: .normal)
        headerButton.contentHorizontalAlignment = .left
        headerButton.addTarget(self, action: #selector(toggleExpand), for: .touchUpInside)
        headerButton.titleLabel?.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .bold)
        
        let fullNameRow = makeRow(title: AppConstant.Booking.fullNameTitle,
                                  placeholder: AppConstant.Booking.fullNamePlaceholder,
                                  shouldStyleOnEdit: true)
        
        let certificateButton = UIButton(type: .system)
        certificateButton.setTitle(AppConstant.Booking.uploadCertificateButtonTitle, for: .normal)
        certificateButton.setTitleColor(.primaryOrange, for: .normal)
        certificateButton.titleLabel?.font = .roboto(.medium, size: 13)
        certificateButton.addTarget(self, action: #selector(handleUploadTap), for: .touchUpInside)
        
        let certificateRow = UIStackView(arrangedSubviews: [
            UILabel.makeLabel(text: AppConstant.Booking.medicalCertificateTitle, font: .roboto(.medium, size: 13)),
            UIView(),
            certificateButton
        ])
        certificateRow.axis = .horizontal
        certificateRow.alignment = .center
        
        // Content (hidden by default)
        contentStack.axis = .vertical
        contentStack.spacing = 8
        contentStack.addArrangedSubview(fullNameRow)
        contentStack.addArrangedSubview(certificateRow)
        contentStack.isHidden = true
        
        let mainStack = UIStackView(arrangedSubviews: [headerButton, contentStack])
        mainStack.axis = .vertical
        mainStack.spacing = 8
        
        addSubview(mainStack)
        mainStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc private func handleUploadTap(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1,
                       animations: {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        },
                       completion: { _ in
            UIView.animate(withDuration: 0.1) {
                sender.transform = .identity
            }
        })
        onUploadCertificateTapped?()
    }
    
    @objc private func toggleExpand() {
        isExpanded.toggle()
        let baseText = headerButton.title(for: .normal) ?? ""
        let namePart = baseText.dropFirst(2)
        headerButton.setTitle("\(isExpanded ? AppConstant.Booking.collapseSymbol : AppConstant.Booking.expandedSymbol) \(namePart)", for: .normal)
        
        UIView.animate(withDuration: 0.25) {
            self.contentStack.isHidden = !self.isExpanded
            self.layoutIfNeeded()
        }
    }
    
    func updateCertificateUploaded() {
        for view in contentStack.arrangedSubviews {
            if let row = view as? UIStackView {
                for case let button as UIButton in row.arrangedSubviews {
                    if button.title(for: .normal) == AppConstant.Booking.uploadCertificateButtonTitle {
                        button.setTitle(AppConstant.Booking.certificateUploadedTitle, for: .normal)
                        button.setTitleColor(.systemGreen, for: .normal)
                    }
                }
            }
        }
    }
    
    // Creates a row with a label and textfield.
    private func makeRow(title: String, placeholder: String, shouldStyleOnEdit: Bool = false) -> UIStackView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .roboto(.medium, size: 13)
        titleLabel.textColor = .black
        
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.textAlignment = .right
        textField.font = .italicSystemFont(ofSize: 13)
        textField.textColor = .primaryGrayDisableText
        
        if shouldStyleOnEdit {
            textField.delegate = self
        }
        
        let row = UIStackView(arrangedSubviews: [titleLabel, textField])
        row.axis = .horizontal
        row.distribution = .fillProportionally
        return row
    }
}

// MARK: - UITextFieldDelegate
extension CompanionCardView: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateStyle(for: textField)
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let rangeOfTextToReplace = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: rangeOfTextToReplace, with: string)
        
        if !updatedText.isEmpty {
            textField.font = .roboto(.bold, size: 13)
            textField.textColor = .primaryOrange
        } else {
            textField.font = .italicSystemFont(ofSize: 13)
            textField.textColor = .primaryGrayDisableText
        }
        
        return true
    }
    
    private func updateStyle(for textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            textField.font = .roboto(.bold, size: 13)
            textField.textColor = .primaryOrange
        } else {
            textField.font = .italicSystemFont(ofSize: 13)
            textField.textColor = .primaryGrayDisableText
        }
    }
}

private extension UILabel {
    static func makeLabel(text: String, font: UIFont) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = .black
        return label
    }
}
