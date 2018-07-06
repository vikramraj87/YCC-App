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
    
    static var picturesFolder: URL = {
        let fm = FileManager.default
        let picturesDirectory = fm.urls(for: .picturesDirectory, in: .userDomainMask).first!
        let appPicturesDirectory = picturesDirectory.appendingPathComponent("YCC App")
        
        if fm.fileExists(atPath: appPicturesDirectory.path) {
            return appPicturesDirectory
        }
        
        do {
            try fm.createDirectory(at: appPicturesDirectory,
                                   withIntermediateDirectories: false,
                                   attributes: nil)
        } catch {
            print(error)
        }
        
        return appPicturesDirectory
    }()
    
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
        let ext = createOp.imageURL.pathExtension
        let dest = destination(forDealer: dealerName,
                               jewelID: jewelID,
                               ext: ext)
        do {
            try FileManager.default.copyItem(at: source, to: dest)
        } catch {
            print(error)
        }
    }
    
    func destination(forDealer dealerName: String, jewelID: String, ext: String) -> URL {
        let dealerFolder = folder(forDealer: dealerName)
        let dest = dealerFolder.appendingPathComponent(jewelID)
        return dest.appendingPathExtension(ext)
    }
    
    
    func folder(forDealer dealerName: String) -> URL {
        let dealerDirectory = CopyImageOperation.picturesFolder.appendingPathComponent(dealerName)
        let fm = FileManager.default
        if fm.fileExists(atPath: dealerDirectory.path) {
            return dealerDirectory
        }
        
        do {
            try fm.createDirectory(at: dealerDirectory,
                                   withIntermediateDirectories: false,
                                   attributes: nil)
        } catch {
            print(error)
        }
        
        return dealerDirectory
    }
}
