//
//  FailedValidationReason.swift
//  YCC App 3
//
//  Created by Vikram Raj Gopinathan on 01/07/18.
//  Copyright © 2018 Vikram Raj Gopinathan. All rights reserved.
//

import Foundation

enum FailedValidationReason {
    // Regex validation
    case patternMismatch
    
    // NotEmpty validation
    case empty
    
    // Length validation
    case short
    case long
}
