//
//  ValidationResult.swift
//  YCC App 3
//
//  Created by Vikram Raj Gopinathan on 01/07/18.
//  Copyright © 2018 Vikram Raj Gopinathan. All rights reserved.
//

import Foundation

enum ValidationResult: Equatable {
    case valid
    case invalid(FailedValidationReason)
}

func ==(lhs: ValidationResult, rhs: ValidationResult) -> Bool {
    switch(lhs, rhs) {
    case (.valid, .valid):
        return true
    case let (.invalid(lhsReason), .invalid(rhsReason)):
        return lhsReason == rhsReason
    default:
        return false
    }
}
