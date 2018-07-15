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
    var dealersViewController: ROSelectionViewController<RODealer, SelectDealerOperation>?
    
    var canRun: () -> Bool = {
        return true
    }
    
    init(presentingViewController: NSViewController) {
        self.presentingViewController = presentingViewController
    }
    
    override func main() {
        guard !isCancelled else {
            setFinished(true)
            return
        }
        
        guard canRun() else {
            setFinished(true)
            return
        }
        
        setExecuting(true)
        
        guard let realm = try? Realm() else {
            print("Not able to fetch Realm instance")
            return
        }
        let allDealers = Array(realm.objects(RODealer.self).sorted(byKeyPath: "name"))
        dealersViewController = ROSelectionViewController<RODealer, SelectDealerOperation>()
        dealersViewController!.items = allDealers
        dealersViewController!.delegate = self
        presentingViewController.presentViewControllerAsModalWindow(dealersViewController!)
    }
}

extension SelectDealerOperation: ROSelectionViewControllerDelegate {
    func selectionMade(_ itemRef: ThreadSafeReference<RODealer>?) {
        guard let dealerRef = itemRef else {
            return
        }
        selectedDealerRef = dealerRef
        dealersViewController?.dismiss(self)
        self.setExecuting(false)
        self.setFinished(true)
    }
    
    typealias T = RODealer
    func modalWindowClosed() {
        self.setExecuting(false)
        self.setFinished(true)
    }
}
