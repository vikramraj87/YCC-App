//
//  String+highlight.swift
//  YCC App
//
//  Created by Vikram Raj Gopinathan on 05/07/18.
//  Copyright © 2018 Vikram Raj Gopinathan. All rights reserved.
//

import Cocoa

extension String {
    func highlight(_ substr: String, with color: NSColor = .systemYellow) -> NSAttributedString {
        let attributed = NSMutableAttributedString(string: self)
        guard !substr.isEmpty,
            let highlightRange = uppercased().range(of: substr.uppercased())
            else {
                return attributed
        }
        attributed.addAttribute(NSAttributedStringKey.backgroundColor,
                                value: color,
                                range: NSRange(highlightRange, in: self))
        return attributed
    }
}
