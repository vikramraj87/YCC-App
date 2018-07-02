//
//  NumberValidatorTests.swift
//  YCC AppTests
//
//  Created by Vikram Raj Gopinathan on 02/07/18.
//  Copyright © 2018 Vikram Raj Gopinathan. All rights reserved.
//

import XCTest

class NumberValidatorTests: XCTestCase {
    var validator: DecimalValidator!
    override func setUp() {
        super.setUp()
        validator = DecimalValidator()
    }
    
    func testValidNumbers() {
        let inputs = [
            "45.6",
            "56.90",
            "12.49",
            "34"
        ]
        inputs.forEach { input in
            XCTAssertEqual(ValidationResult.valid, validator.validate(input))
        }
    }
    
    func testInvalidNumbers() {
        let inputs = [
            "45.78.90",
            " 45",
            "56 ",
            "4 5",
            "09.5",
            "09",
            "23 .45",
            "34. 56",
            "45."
        ]
        inputs.forEach { input in
            let expected = ValidationResult.invalid(.patternMismatch)
            let result = validator.validate(input)
            XCTAssertEqual(expected, result)
        }
    }

}
