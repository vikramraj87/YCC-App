//
//  File.swift
//  YCC App
//
//  Created by Vikram Raj Gopinathan on 02/07/18.
//  Copyright © 2018 Vikram Raj Gopinathan. All rights reserved.
//

import Foundation

class DecimalValidator: RegexValidator {
    init() {
        super.init(pattern: "^[1-9][0-9]*(?:\\.[0-9]+)?$", options: .caseInsensitive)!
    }
}
