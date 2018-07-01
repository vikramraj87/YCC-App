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
    let fileName: String
    
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
    
    var destination: URL {
        let fileWithoutExtension = CopyImageOperation.picturesFolder.appendingPathComponent(fileName)
        return fileWithoutExtension.appendingPathExtension(source.pathExtension)
    }
    
    init(source: URL, fileName: String) {
        self.source = source
        self.fileName = fileName
    }
    
    override func main() {
        guard !self.isCancelled else { return }
        do {
            try FileManager.default.copyItem(at: source, to: destination)
        } catch {
            print(error)
        }
    }
}
