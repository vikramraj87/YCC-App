//
//  ImportJewelsViewController.swift
//  YCC App 3
//
//  Created by Vikram Raj Gopinathan on 01/07/18.
//  Copyright © 2018 Vikram Raj Gopinathan. All rights reserved.
//

import Cocoa
import RealmSwift

class ImportJewelsViewController: NSViewController {
    var selectedFolder: URL?
    var selectedFiles: [URL]?
    var selectedDealerRef: ThreadSafeReference<RODealer>?
    
    @IBOutlet var progressBar: NSProgressIndicator!
    @IBOutlet var fromLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var filesRemaining = 0
    
    override func viewDidAppear() {
        guard let folder = selectedFolder,
            let files = selectedFiles,
            let dealerRef = selectedDealerRef
        else {
                print("No folder selected or no files in the folder")
                return
        }
        
        resetUI(withSelectedFolder: folder, andFiles: files)
        startCopyOperations(withSelectedFiles: files, under: dealerRef)
    }
    
    @IBAction func cancelClicked(_ sender: NSButton) {
        // Cancel imports
        dismiss(self)
    }
    
    private func startCopyOperations(withSelectedFiles files: [URL],
                                     under dealerRef: ThreadSafeReference<RODealer>) {
        var createOperations: [CreateJewelOperation] = []
        var copyOperations: [CopyImageOperation] = []
        
        guard let realm = try? Realm(),
            let dealer = realm.resolve(dealerRef) else {
                return
        }
        
        for file in files {
            let createOperation = CreateJewelOperation(dealerRef: ThreadSafeReference(to: dealer), imageURL: file)
            let copyOperation = CopyImageOperation(createJewelOp: createOperation)
            copyOperation.addDependency(createOperation)
            
            createOperations.append(createOperation)
            copyOperations.append(copyOperation)
            
            copyOperation.completionBlock = {
                DispatchQueue.main.async { [unowned self] in
                    self.filesRemaining -= 1
                    self.progressBar.doubleValue += 1.0
                    if self.filesRemaining == 0 {
                        self.dismiss(self)
                    }
                }
            }
        }
//        let copyOperations: [CopyImageOperation] = files.map {
//            let op = CopyImageOperation(source: $0, fileName: $0.lastPathComponent)
//            op.completionBlock = {
//                // Update the view in main queue
//                DispatchQueue.main.async { [unowned self] in
//                    self.filesRemaining -= 1
//                    self.progressBar.doubleValue += 1.0
//                    if self.filesRemaining == 0 {
//                        self.dismiss(self)
//                    }
//                }
//            }
//            return op
//        }
//        
        let opQueue = OperationQueue()
        opQueue.qualityOfService = .userInitiated
        var ops: [Operation] = copyOperations
        ops.append(contentsOf: createOperations)
        opQueue.addOperations(ops, waitUntilFinished: false)
    }
    
    private func resetUI(withSelectedFolder folder: URL, andFiles files: [URL]) {
        // Reset progress bar
        progressBar.minValue = 0.0
        progressBar.maxValue = Double(files.count)
        progressBar.doubleValue = 0.0
        
        // Set state
        filesRemaining = files.count
        
        // Set label
        fromLabel.stringValue = "Importing \(files.count) jewels from \(folder.lastPathComponent)"
    }
}
