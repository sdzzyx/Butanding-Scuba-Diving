//
//  ExtensionString.swift
//  BicolScubaDiving
//
//  Created by Melvin Ballesteros on 6/23/25.
//

import UIKit

extension String {
    func ranges(of search: String) -> [Range<String.Index>] {
        var result: [Range<String.Index>] = []
        var start = startIndex
        
        while let range = range(of: search, options: .caseInsensitive, range: start..<endIndex) {
            result.append(range)
            start = range.upperBound
        }
        
        return result
    }
}
