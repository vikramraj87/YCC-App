//
//  SelectDealerOperation.swift
//  YCC App
//
//  Created by Vikram Raj Gopinathan on 05/07/18.
//  Copyright © 2018 Vikram Raj Gopinathan. All rights reserved.
//

import Cocoa
import RealmSwift

class SelectDealerOperation: AsyncOperation {
    var selectedDealerRef: ThreadSafeReference<RODealer>?
    let presentingViewController: NSViewController
    weak var selectFolderOp: SelectFolderOperation?
    
    init(presentingViewController: NSViewController,
         selectFolderOperation: SelectFolderOperation) {
        self.presentingViewController = presentingViewController
        self.selectFolderOp = selectFolderOperation
    }
    
    override func main() {
        guard !isCancelled else {
            setFinished(true)
            return
        }
        
        guard let files = selectFolderOp?.selectedFiles,
            files.count > 0
        else {
            setFinished(true)
            return
        }
        
        setExecuting(true)
        
        guard let realm = try? Realm() else {
            print("Not able to fetch Realm instance")
            return
        }
        let allDealers = Array(realm.objects(RODealer.self).sorted(byKeyPath: "name"))
        let selectItemVC = ROSelectionViewController<RODealer, SelectDealerOperation>()
        selectItemVC.items = allDealers
        selectItemVC.delegate = self
        presentingViewController.presentViewControllerAsModalWindow(selectItemVC)
    }
}

extension SelectDealerOperation: ROSelectionViewControllerDelegate {
    func selectionMade(_ itemRef: ThreadSafeReference<RODealer>) {
        selectedDealerRef = itemRef
        self.setExecuting(false)
        self.setFinished(true)
    }
    
    typealias T = RODealer
    func modalWindowClosed() {
        self.setExecuting(false)
        self.setFinished(true)
    }
}
