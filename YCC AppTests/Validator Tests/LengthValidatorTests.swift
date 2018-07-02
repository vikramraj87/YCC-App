//
//  LengthValidatorTests.swift
//  YCC AppTests
//
//  Created by Vikram Raj Gopinathan on 02/07/18.
//  Copyright © 2018 Vikram Raj Gopinathan. All rights reserved.
//

import XCTest

class LengthValidatorTests: XCTestCase {
    var validator: LengthValidator!

    override func setUp() {
        super.setUp()
        validator = LengthValidator(min: 3, max: 30)
    }
    
    func testShortStrings() {
        let shortInputs = [
            "is",
            "a",
            "1"
        ]
        
        shortInputs.forEach { input in
            let result = validator.validate(input)
            let expected = ValidationResult.invalid(.short)
            XCTAssertEqual(expected, result)
        }
    }
    
    func testLongStrings() {
        let longString = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
        let result = validator.validate(longString)
        let expected = ValidationResult.invalid(.long)
        XCTAssertEqual(expected, result)
    }
    
    func testCorrectLengthStrings() {
        let inputs = [
            "Kim",
            "Lorem ipsum dolor sit posuere.",
            "Arham"
        ]
        inputs.forEach { input in
            let result = validator.validate(input)
            XCTAssertEqual(result, ValidationResult.valid)
        }
    }
    
}
