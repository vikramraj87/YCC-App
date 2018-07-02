//
//  LengthValidator.swift
//  YCC App
//
//  Created by Vikram Raj Gopinathan on 02/07/18.
//  Copyright © 2018 Vikram Raj Gopinathan. All rights reserved.
//

import Foundation

class LengthValidator: Validator {
    let min: Int
    let max: Int
    
    init(min: Int, max: Int) {
        self.min = min
        self.max = max
    }
    
    func validate(_ input: String) -> ValidationResult {
        if input.count < min { return .invalid(.short) }
        if input.count > max { return .invalid(.long) }
        return .valid
    }
}
