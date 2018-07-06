//
//  CreateJewelOperation.swift
//  YCC App
//
//  Created by Vikram Raj Gopinathan on 06/07/18.
//  Copyright © 2018 Vikram Raj Gopinathan. All rights reserved.
//

import Foundation
import RealmSwift

class CreateJewelOperation: Operation {
    let dealerRef: ThreadSafeReference<RODealer>
    let imageURL: URL
    var jewelID: String?
    var dealerName: String?
    
    init(dealerRef: ThreadSafeReference<RODealer>, imageURL: URL) {
        self.dealerRef = dealerRef
        self.imageURL = imageURL
    }
    
    override func main() {
        guard !isCancelled else { return }
        
        guard let realm = try? Realm() else {
            print("Not able to fetch Realm instance")
            return
        }
        guard let dealer = realm.resolve(dealerRef) else {
            print("Cannot resolve dealer")
            return
        }
        
        let jewel = ROJewel()
        dealerName = dealer.name
        
        try? realm.write {
            dealer.jewelObjects.append(jewel)
        }
        
        jewelID = jewel.id
    }
}
