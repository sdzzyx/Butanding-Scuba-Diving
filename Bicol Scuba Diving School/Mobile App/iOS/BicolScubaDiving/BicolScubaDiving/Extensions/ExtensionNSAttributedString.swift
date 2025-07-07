//
//  ExtensionNSAttributedString.swift
//  BicolScubaDiving
//
//  Created by Lenard Cortuna on 7/3/25.
//

import UIKit

extension NSAttributedString {
    struct HighlightStyle {
        let substring: String
        let font: UIFont
        let color: UIColor
    }
    
    static func highlightedString(
        fullText: String,
        baseFont: UIFont,
        baseColor: UIColor,
        highlights: [HighlightStyle]
    ) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(
            string: fullText,
            attributes: [
                .font: baseFont,
                .foregroundColor: baseColor
            ]
        )
        
        for highlight in highlights {
            let ranges = fullText.ranges(of: highlight.substring)
            for range in ranges {
                let nsRange = NSRange(range, in: fullText)
                attributedString.addAttributes([
                    .font: highlight.font,
                    .foregroundColor: highlight.color
                ], range: nsRange)
            }
        }
        
        return attributedString
    }
}
