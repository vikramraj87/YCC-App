//
//  CreateDealerViewController.swift
//  YCC App 3
//
//  Created by Vikram Raj Gopinathan on 01/07/18.
//  Copyright © 2018 Vikram Raj Gopinathan. All rights reserved.
//

import Cocoa
import RealmSwift

class CreateDealerViewController: NSViewController {
    enum FormField {
        case name
        case mobileNumber
        case shipping
        case multiplicationFactor
    }
    
    @IBOutlet var nameTextField: NSTextField!
    @IBOutlet var mobileNumberTextField: NSTextField!
    
    @IBOutlet var usualShippingTextField: NSTextField!
    @IBOutlet var multiplicationFactorTextField: NSTextField!
    
    @IBOutlet var nameValidationLabel: NSTextField!
    @IBOutlet var mobileValidationLabel: NSTextField!
    
    @IBOutlet var shippingValidationLabel: NSTextField!
    @IBOutlet var multiplicationValidationLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        resetInputFields()
    }
    
    private func resetInputFields() {
        nameTextField.stringValue = ""
        mobileNumberTextField.stringValue = ""
        usualShippingTextField.stringValue = ""
        multiplicationFactorTextField.stringValue = ""
        
        nameValidationLabel.isHidden = true
        mobileValidationLabel.isHidden = true
        shippingValidationLabel.isHidden = true
        multiplicationValidationLabel.isHidden = true
    }
    
    @IBAction func saveDealer(_ sender: NSButton) {
        guard validate() else { return }
        
        let dealer = RODealer()
        dealer.name = nameTextField.stringValue
        dealer.mobileNumber = mobileNumberTextField.stringValue
        
        if !usualShippingTextField.stringValue.isEmpty {
            dealer.usualShippingCost = usualShippingTextField.floatValue
        }
        
        if !multiplicationFactorTextField.stringValue.isEmpty {
            dealer.codeMultiplicationFactor = multiplicationFactorTextField.floatValue
        }
        
        guard let realm = try? Realm() else {
            print("Not able to obtain Realm instance")
            return
        }
        
        guard !isDuplicate(dealer: dealer, realm: realm) else { return }
        
        do {
            try realm.write {
                realm.add(dealer)
            }
        } catch {
            print(error)
        }
        
        
        
        dismiss(self)
    }
    
    private func validate() -> Bool {
        var isValid = true
        
        let textFieldsToValidate = [
            nameTextField,
            mobileNumberTextField,
            usualShippingTextField,
            multiplicationFactorTextField
        ]
        
        for textField in textFieldsToValidate {
            let field = self.field(for: textField!)
            let validator = self.validator(for: field)
            let result = validator.validate(textField!.stringValue)
            
            switch result {
            case .invalid(let reason):
                isValid = false
                displayFailedValidationReason(reason, for: field)
            case .valid:
                validationLabel(for: field)?.isHidden = true
            }
        }
        
        return isValid
    }
    
    private func isDuplicate(dealer: RODealer, realm: Realm) -> Bool {
        let namePredicate = NSPredicate(format: "name ==[c] %@", dealer.name)
        var duplicate = realm.objects(RODealer.self).filter(namePredicate)
        
        if duplicate.count > 0 {
            displayValidationMessage("Name already exists", for: .name)
            return true
        }
        
        let mobileNumberPredicate = NSPredicate(format: "mobileNumber ==[c] %@", dealer.mobileNumber)
        duplicate = realm.objects(RODealer.self).filter(mobileNumberPredicate)
        
        if duplicate.count > 0 {
            displayValidationMessage("Mobile number exists", for: .mobileNumber)
            return true
        }
        
        return false
    }
    
    private func displayValidationMessage(_ message: String, for field: FormField) {
        guard let validationLabel = validationLabel(for: field) else { return }
        validationLabel.stringValue = message
        validationLabel.isHidden = false
    }
    
    private func displayFailedValidationReason(_ reason: FailedValidationReason, for field: FormField) {
        guard let validationLabel = validationLabel(for: field),
            let message = validationMessage(for: field, reason: reason) else {
                return
        }
        validationLabel.stringValue = message
        validationLabel.isHidden = false
    }
    
    private func validationMessage(for field: FormField, reason: FailedValidationReason) -> String? {
        switch (field, reason) {
        case (.name, .short):
            return "Name too short."
        case (.name, .long):
            return "Name too long."
        case (.name, .patternMismatch):
            return "Invalid characters."
        case (.mobileNumber, .short):
            return "Mobile number too short."
        case (.mobileNumber, .long):
            return "Mobile number too long."
        case (.mobileNumber, .patternMismatch):
            return "Invalid characters."
        case (.shipping, .patternMismatch):
            return "Invalid characters."
        case (.multiplicationFactor, .patternMismatch):
            return "Invalid characters."
        default:
            return nil
        }
    }
    
    private func field(for textField: NSTextField) -> FormField {
        switch textField {
        case nameTextField:
            return .name
        case mobileNumberTextField:
            return .mobileNumber
        case usualShippingTextField:
            return .shipping
        case multiplicationFactorTextField:
            return .multiplicationFactor
        default:
            fatalError("Invalid form field")
        }
    }
    
    private func validator(for field: FormField) -> Validator {
        switch field {
        case .name:
            return ValidatorChain(validators: [
                LengthValidator(min: 3, max: 30),
                NameValidator()
            ])
        case .mobileNumber:
            return ValidatorChain(validators: [
                LengthValidator(min: 6, max: 12),
                IntegerValidator()
            ])
        case .shipping, .multiplicationFactor:
            return DecimalValidator()
            
        }
    }
    
    private func validationLabel(for field: FormField) -> NSTextField? {
        switch field {
        case .name:
            return nameValidationLabel
        case .mobileNumber:
            return mobileValidationLabel
        case .shipping:
            return shippingValidationLabel
        case .multiplicationFactor:
            return multiplicationValidationLabel
        }
    }
    
}
