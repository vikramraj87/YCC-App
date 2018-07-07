//
//  AppDirectory.swift
//  YCC App
//
//  Created by Vikram Raj Gopinathan on 07/07/18.
//  Copyright © 2018 Vikram Raj Gopinathan. All rights reserved.
//

import Foundation

class AppDirectory {
    private static let fm = FileManager.default
    
    private static var picturesFolder: URL = {
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
    
    private static func destination(forDealer dealerName: String, jewelID: String, ext: String) -> URL {
        let dealerFolder = folder(forDealer: dealerName)
        let dest = dealerFolder.appendingPathComponent(jewelID)
        return dest.appendingPathExtension(ext)
    }
    
    
    private static func folder(forDealer dealerName: String) -> URL {
        let dealerDirectory = picturesFolder.appendingPathComponent(dealerName)
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
    
    static func copyImage(at source: URL, underDealer dealerName: String, withJewelID id: String) {
        let ext = source.pathExtension
        let dest = destination(forDealer: dealerName,
                               jewelID: id,
                               ext: ext)
        do {
            try fm.copyItem(at: source, to: dest)
        } catch {
            print(error)
        }
    }
}
