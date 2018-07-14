//
//  SelectJewelViewController.swift
//  YCC App
//
//  Created by Vikram Raj Gopinathan on 14/07/18.
//  Copyright © 2018 Vikram Raj Gopinathan. All rights reserved.
//

import Cocoa
import RealmSwift

extension NSUserInterfaceItemIdentifier {
    static let jewelItem = NSUserInterfaceItemIdentifier(rawValue: "JewelCollectionViewItem")
}

class SelectJewelViewController: NSViewController {
    let scrollView = NSScrollView()
    let collectionView = NSCollectionView(frame: .zero)
    var jewels: Results<ROJewel>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configCollectionView()
        
        guard let realm = try? Realm() else {
            print("Realm instance not available")
            return
        }
        
        jewels  = realm.objects(ROJewel.self).sorted(byKeyPath: "addedOn", ascending: false)
        collectionView.reloadData()
    }
    
    override func loadView() {
        let rect = NSRect(x: 0, y: 0, width: 400, height: 300)
        view = NSView(frame: rect)
    }
    
    private func configCollectionView() {
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        scrollView.documentView = collectionView
        let layout = NSCollectionViewFlowLayout()
        
        layout.minimumLineSpacing = 4
        layout.sectionInset = NSEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        layout.itemSize = NSSize(width: 120, height: 160.0)
        
        collectionView.dataSource = self
        collectionView.collectionViewLayout = layout
    }
    
}

extension SelectJewelViewController: NSCollectionViewDataSource {
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return jewels?.count ?? 0
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: .jewelItem, for: indexPath)
        guard let jewelItem = item as? JewelCollectionViewItem else {
            print("Cannot cast collection view item to JewelCollectionViewItem")
            return item
        }
        
        guard let jewels = jewels else { return jewelItem }
        let jewel = jewels[indexPath.item]
        let dealerName = jewel.dealer.name
        let jewelId = jewel.id
        jewelItem.imageView?.image = nil
        DispatchQueue.global(qos: .userInitiated).async {
            let dealerFolder = AppDirectory.folder(forDealer: dealerName)
            let imageFileName = dealerFolder.appendingPathComponent(jewelId)
            let fm = FileManager.default
            var imageFile = imageFileName.appendingPathExtension("jpg")
            if !fm.fileExists(atPath: imageFile.path) {
                imageFile = imageFileName.appendingPathExtension("jpeg")
            }
            if !fm.fileExists(atPath: imageFile.path) {
                print("File not exist")
                return
            }
            DispatchQueue.main.async {
                jewelItem.imageView?.image = NSImage(contentsOf: imageFile)
            }
        }
        
        
        return jewelItem
    }
    
    
}
