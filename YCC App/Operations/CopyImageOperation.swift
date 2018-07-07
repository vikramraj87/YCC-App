//
//  CopyImageOperation.swift
//  YCC App 3
//
//  Created by Vikram Raj Gopinathan on 01/07/18.
//  Copyright © 2018 Vikram Raj Gopinathan. All rights reserved.
//

import Foundation


class CopyImageOperation: Operation {
    let source: URL
    let createOp: CreateJewelOperation
    
    init(createJewelOp: CreateJewelOperation) {
        self.source = createJewelOp.imageURL
        self.createOp = createJewelOp
    }
    
    override func main() {
        guard !self.isCancelled else { return }
        
        guard let dealerName = createOp.dealerName,
            let jewelID = createOp.jewelID else {
                return
        }
        
        AppDirectory.copyImage(at: source, underDealer: dealerName, withJewelID: jewelID)
    }
}
