//
//  TermsView.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 9/27/25.
//

import UIKit
import SnapKit

class TermsView: UIView {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.font = .systemFont(ofSize: 14)
        tv.textColor = .label
        tv.isScrollEnabled = true
        return tv
    }()
    
    let acceptButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Accept", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .primaryOrange
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeTermsText(_ fullText: String) -> NSAttributedString {
        let attributed = NSMutableAttributedString(string: fullText)
        
        // --- Normal paragraph style (base) ---
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        paragraphStyle.paragraphSpacing = 8
        
        attributed.addAttributes([
            .font: UIFont.roboto(.regular, size: 14),
            .foregroundColor: UIColor.black,
            .paragraphStyle: paragraphStyle
        ], range: NSRange(location: 0, length: attributed.length))
        
        // --- Title style (centered) ---
        if let titleRange = (fullText as NSString)
            .range(of: "Terms & Privacy Policy", options: .caseInsensitive)
            .toOptional() {
            
            let titleParagraphStyle = NSMutableParagraphStyle()
            titleParagraphStyle.alignment = .center
            titleParagraphStyle.paragraphSpacing = 8
            
            attributed.addAttributes([
                .font: UIFont.roboto(.bold, size: 18),
                .foregroundColor: UIColor.primaryBlueColor,
                .paragraphStyle: titleParagraphStyle
            ], range: titleRange)
        }
        
        // --- Bullet alignment ---
        let bulletParagraphStyle = NSMutableParagraphStyle()
        bulletParagraphStyle.lineSpacing = 4
        bulletParagraphStyle.paragraphSpacing = 8
        bulletParagraphStyle.headIndent = 20 // indent wrapped lines
        bulletParagraphStyle.firstLineHeadIndent = 0
        
        let lines = fullText.components(separatedBy: "\n")
        var location = 0
        for line in lines {
            let lineRange = NSRange(location: location, length: line.count)
            if line.trimmingCharacters(in: .whitespaces).hasPrefix("•") {
                attributed.addAttributes([
                    .paragraphStyle: bulletParagraphStyle
                ], range: lineRange)
            }
            location += line.count + 1
        }
        
        return attributed
    }
    
    private func setupLayout() {
        addSubview(textView)
        addSubview(acceptButton)
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(acceptButton.snp.top).offset(-16)
        }
        
        acceptButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(16)
            make.height.equalTo(50)
        }
    }
    
    func configure(with viewModel: TermsViewModel) {
        textView.attributedText = makeTermsText(viewModel.termsText)
    }
}

extension NSRange {
    func toOptional() -> NSRange? {
        return location != NSNotFound ? self : nil
    }
}
