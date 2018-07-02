//
//  ValidatorChain.swift
//  YCC App
//
//  Created by Vikram Raj Gopinathan on 02/07/18.
//  Copyright © 2018 Vikram Raj Gopinathan. All rights reserved.
//

import Foundation

class ValidatorChain: Validator {
    private let validators: [Validator]
    
    init(validators: [Validator]) {
        self.validators = validators
    }
    
    func validate(_ input: String) -> ValidationResult {
        for validator in validators {
            let result = validator.validate(input)
            if result == .valid {
                continue
            }
            return result
        }
        return .valid
    }
}
