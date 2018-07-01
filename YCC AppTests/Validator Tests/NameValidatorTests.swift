//
//  NameValidator.swift
//  YCC App 3 Tests
//
//  Created by Vikram Raj Gopinathan on 01/07/18.
//  Copyright © 2018 Vikram Raj Gopinathan. All rights reserved.
//

import XCTest


class NameValidatorTests: XCTestCase {
    var validator: NameValidator!

    override func setUp() {
        super.setUp()
        validator = NameValidator()
    }
    
    func testInvalidNames() {
        let invalidNames = [
            "K1rthika Vikram", // Contains number
            "Kirthika  Vikram", // Contains extra space
            " Kirthika Vikram", // Starting with space
            "Kirthika Vikram " // Ending with space
        ]
        invalidNames.forEach { (name: String) in
            let expectedResult = ValidationResult.invalid(.patternMismatch)
            let result = self.validator.validate(name)
            XCTAssertEqual(expectedResult, result)
        }
    }
    
    func testValidName() {
        let validNames = [
            "Vikram Raj Gopinathan",
            "Kirthika Vikram",
            "Aakarshan",
            "Ambika Jewels",
            "Arham collections"
        ]
        
        validNames.forEach { (name: String) in
            XCTAssertEqual(ValidationResult.valid, validator.validate(name))
        }
    }


}
