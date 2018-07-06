//
//  SelectFolderOperation.swift
//  YCC App 3
//
//  Created by Vikram Raj Gopinathan on 01/07/18.
//  Copyright © 2018 Vikram Raj Gopinathan. All rights reserved.
//

import Cocoa

extension NSOpenPanel {
    var selectedFolder: URL? {
        title = "Select folder to Import"
        allowsMultipleSelection = false
        canChooseFiles = false
        canChooseDirectories = true
        
        return runModal() == .OK ? urls.first : nil
    }
}

class SelectFolderOperation: Operation {
    var selectedFolder: URL?
    var selectedFiles: [URL]?
    
    static let fileTypes = ["jpg", "jpeg"].map { return $0.uppercased() }
    
    override func main() {
        guard !self.isCancelled else { return }
        guard let url = NSOpenPanel().selectedFolder else { return }
        
        selectedFolder = url
        
        let fm = FileManager.default
        guard let files = try? fm.contentsOfDirectory(atPath: url.path) else {
            print("Cannot access files from directory: \(url.path)")
            return
        }
        
        selectedFiles = files.map { (fileName: String) -> URL in
            return url.appendingPathComponent(fileName)
        }.filter { (file: URL) -> Bool in
            return SelectFolderOperation.fileTypes.contains(file.pathExtension.uppercased())
        }
    }
}
