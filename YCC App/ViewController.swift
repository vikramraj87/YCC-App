//
//  ViewController.swift
//  YCC App
//
//  Created by Vikram Raj Gopinathan on 01/07/18.
//  Copyright © 2018 Vikram Raj Gopinathan. All rights reserved.
//

import Cocoa
import RealmSwift

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func importJewels(_ sender: Any) {
        let selectFolderOp = SelectFolderOperation()
        let selectDealerOp = SelectDealerOperation(presentingViewController: self)
        selectDealerOp.canRun = {
            guard let files = selectFolderOp.selectedFiles,
                files.count > 0 else {
                    return false
            }
            return true
        }
        
        
        let showProgressOp = BlockOperation {
            guard let folder = selectFolderOp.selectedFolder else { return }
            guard let files = selectFolderOp.selectedFiles else { return }
            guard let dealerRef = selectDealerOp.selectedDealerRef else { return }

            let vc = NSStoryboard.main!.instantiateController(withIdentifier: .importJewels) as! ImportJewelsViewController
            vc.selectedFolder = folder
            vc.selectedFiles = files
            vc.selectedDealerRef = dealerRef
            self.presentViewControllerAsModalWindow(vc)
        }
        
        selectDealerOp.addDependency(selectFolderOp)
        showProgressOp.addDependency(selectDealerOp)
        
        OperationQueue.main.addOperations([showProgressOp,
                                           selectFolderOp,
                                           selectDealerOp],
                                          waitUntilFinished: false)
    }
    
    @IBAction func createDealer(_ sender: Any) {
        let vc = NSStoryboard.main!.instantiateController(withIdentifier: .createDealer) as! CreateDealerViewController
        self.presentViewControllerAsModalWindow(vc)
    }

}

