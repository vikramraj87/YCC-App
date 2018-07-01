//
//  ViewController.swift
//  YCC App
//
//  Created by Vikram Raj Gopinathan on 01/07/18.
//  Copyright © 2018 Vikram Raj Gopinathan. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func importJewels(_ sender: Any) {
        let selectFolderOp = SelectFolderOperation()
        
        let showProgressOp = BlockOperation {
            guard let folder = selectFolderOp.selectedFolder else { return }
            guard let files = selectFolderOp.selectedFiles else { return }
            
            let vc = NSStoryboard.main!.instantiateController(withIdentifier: .importJewels) as! ImportJewelsViewController
            vc.selectedFolder = folder
            vc.selectedFiles = files
            self.presentViewControllerAsModalWindow(vc)
        }
        
        showProgressOp.addDependency(selectFolderOp)
        
        OperationQueue.main.addOperation(showProgressOp)
        OperationQueue.main.addOperation(selectFolderOp)
    }
    
    @IBAction func createDealer(_ sender: Any) {
        let vc = NSStoryboard.main!.instantiateController(withIdentifier: .createDealer) as! CreateDealerViewController
        self.presentViewControllerAsModalWindow(vc)
    }

}

