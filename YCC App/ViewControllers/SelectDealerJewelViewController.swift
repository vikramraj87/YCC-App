//
//  SelectJewelViewController.swift
//  YCC App
//
//  Created by Vikram Raj Gopinathan on 14/07/18.
//  Copyright © 2018 Vikram Raj Gopinathan. All rights reserved.
//

import Cocoa
import RealmSwift

typealias SelectDealerVC = ROSelectionViewController<RODealer, SelectDealerJewelViewController>

class SelectDealerJewelViewController: NSSplitViewController {
    lazy var selectDealerVC: SelectDealerVC = {
        let dealersVC = SelectDealerVC()
        
        var allDealers: [RODealer] = []
        if let realm = try? Realm() {
            allDealers = Array(realm.objects(RODealer.self).sorted(byKeyPath: "name"))
        }
        
        dealersVC.delegate = self
        dealersVC.items = allDealers
        
        return dealersVC
    }()
    
    lazy var selectJewelVC: SelectJewelViewController = {
        let sb = NSStoryboard.main!
        let selectJewelVC = SelectJewelViewController()
        return selectJewelVC
    }()
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        title = "Select Jewel"
        configSplitView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func viewDidLoad() {
        configSplitItems()
    }
    
    private func configSplitView() {
        self.splitView.isVertical = true
    }
    
    private func configSplitItems() {
        let dealersSplitItem = NSSplitViewItem(viewController: selectDealerVC)
        dealersSplitItem.minimumThickness = 240.0
        addSplitViewItem(dealersSplitItem)
        
        let jewelsSplitItem = NSSplitViewItem(viewController: selectJewelVC)
        jewelsSplitItem.minimumThickness = 500.0
        addSplitViewItem(jewelsSplitItem)
    }
}

extension SelectDealerJewelViewController: ROSelectionViewControllerDelegate {
    typealias T = RODealer
    func selectionMade(_ itemRef: ThreadSafeReference<RODealer>?) {
        selectJewelVC.displayJewels(for: itemRef)
    }
    func modalWindowClosed() {
        // not required
    }
}
