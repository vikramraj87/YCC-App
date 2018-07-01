//
//  NameValidator.swift
//  YCC App 3
//
//  Created by Vikram Raj Gopinathan on 01/07/18.
//  Copyright © 2018 Vikram Raj Gopinathan. All rights reserved.
//

import Foundation

class NameValidator: RegexValidator {
    init() {
        super.init(pattern: "^[a-zA-Z]+(?: [a-zA-Z]+)*$", options: .caseInsensitive)!
    }
}
