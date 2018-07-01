//
//  SelectFolderOperation.swift
//  YCC App 3
//
//  Created by Vikram Raj Gopinathan on 01/07/18.
//  Copyright © 2018 Vikram Raj Gopinathan. All rights reserved.
//

import Cocoa

class SelectFolderOperation: Operation {
    var selectedFolder: URL?
    var selectedFiles: [URL]?
    
    static let fileTypes = ["jpg", "jpeg"].map { return $0.uppercased() }
    
    override func main() {
        guard !self.isCancelled else { return }
        guard let url = getURL() else { return }
        
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
    
    private func getURL() -> URL? {
        let panel = NSOpenPanel()
        panel.title = "Select Folder to Import Jewels"
        panel.allowsMultipleSelection = false
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        
        let response = panel.runModal()
        return response == .OK ? panel.urls.first : nil
    }
}
