//
//  Dealer.swift
//  YCC App 3
//
//  Created by Vikram Raj Gopinathan on 01/07/18.
//  Copyright © 2018 Vikram Raj Gopinathan. All rights reserved.
//

import Foundation
import RealmSwift

protocol Dealer {
    var id: String { get set }
    var name: String { get set }
    var usualShippingCost: Float { get }
    var codeMultiplicationFactor: Float { get }
    
}

protocol Jewel {
    var id: String { get set }
    var addedOn: Date { get }
    
    var dealer: Dealer { get }
}

class RODealer: Object, Dealer {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var mobileNumber = ""
    @objc dynamic var usualShippingCost: Float = 0.0
    @objc dynamic var codeMultiplicationFactor: Float = 1.0
    @objc dynamic var createdOn = Date()
    
    let jewelObjects = List<ROJewel>()
    
    var sortedJewels: Results<ROJewel> {
        return jewelObjects.sorted(byKeyPath: "addedOn", ascending: false)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension RODealer: FilterableItem {
    var summary: String {
        return "\(name) (\(mobileNumber))"
    }
    
    func shouldSelect(for query: String) -> Bool {
        let q = query.uppercased()
        if name.uppercased().contains(q) { return true }
        if mobileNumber.uppercased().contains(q) { return true }
        return false
    }
}

class ROJewel: Object, Jewel {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var addedOn = Date()
    @objc dynamic var dealerPrice: Float = 0.0
    
    let dealers = LinkingObjects(fromType: RODealer.self, property: "jewelObjects")
    
    var dealer: Dealer {
        return dealers.first!
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class ROCustomer: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var createdOn = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
