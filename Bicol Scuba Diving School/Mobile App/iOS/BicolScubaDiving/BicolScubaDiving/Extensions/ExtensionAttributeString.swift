//
//  ExtensionAttributeString.swift
//  BicolScubaDiving
//
//  Created by Melvin Ballesteros on 6/23/25.
//

import UIKit

extension NSAttributedString {
    
    static func makeHighlighting(
        fullText: String,
        highlights: [String],
        baseFont: UIFont = .systemFont(ofSize: 14),
        baseTextColor: UIColor = .black,
        highlightFont: UIFont? = nil,
        highlightColor: UIColor = .systemBlue
    ) -> NSAttributedString {
        
        let attributed = NSMutableAttributedString(string: fullText, attributes: [
            .font: baseFont,
            .foregroundColor: baseTextColor
        ])
        
        for word in highlights {
            let ranges = fullText.lowercased().ranges(of: word.lowercased())
            for range in ranges {
                let nsRange = NSRange(range, in: fullText)
                attributed.addAttributes([
                    .font: highlightFont ?? baseFont,
                    .foregroundColor: highlightColor
                ], range: nsRange)
            }
        }
        
        return attributed
    }    
}
