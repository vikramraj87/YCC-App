//
//  RegexValidator.swift
//  YCC App 3
//
//  Created by Vikram Raj Gopinathan on 01/07/18.
//  Copyright © 2018 Vikram Raj Gopinathan. All rights reserved.
//

import Foundation

class RegexValidator: Validator {
    private let regex: NSRegularExpression
    
    init?(pattern: String, options: NSRegularExpression.Options) {
        guard let rg = try? NSRegularExpression(pattern: pattern, options: options) else {
            return nil
        }
        regex = rg
    }
    
    func validate(_ input: String) -> ValidationResult {
        if input.isEmpty { return .valid }
        let fullRange = NSRange(location: 0, length: (input as NSString).length)
        guard let _ = regex.firstMatch(in: input, options: [], range: fullRange) else {
            return .invalid(.patternMismatch)
        }
        return .valid
    }
}
