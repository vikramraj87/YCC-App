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
    let scrollView = NSScrollView(frame: .zero)
    let collectionView = NSCollectionView(frame: .zero)
    var jewels: Results<ROJewel>?
    var urlCache: [String: URL] = [:]
    
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
    
    override func viewDidLayout() {
        super.viewDidLayout()
    }
    
    override func loadView() {
        view = NSView(frame: .zero)
    }
    
    private func configCollectionView() {
        let layout = NSCollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 4
        layout.sectionInset = NSEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        layout.itemSize = NSSize(width: 120, height: 160.0)
        collectionView.collectionViewLayout = layout
        
        scrollView.documentView = collectionView
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        collectionView.dataSource = self
    }
    
}

extension SelectJewelViewController: NSCollectionViewDataSource {
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
        
        self.configCollectionViewItem(jewelItem, with: jewel)
        
        return jewelItem
    }
    
    private func configCollectionViewItem(_ jewelItem: JewelCollectionViewItem,
                                          with jewel: ROJewel) {
        let dealerName = jewel.dealer.name
        let jewelId = jewel.id
        
        DispatchQueue.global(qos: .userInitiated).async {
            guard let imageURL = self.url(forJewelId: jewelId, forDealer: dealerName) else {
                return
            }
            DispatchQueue.main.async {
                jewelItem.textField?.stringValue = dealerName
                jewelItem.imageView?.image = NSImage(contentsOf: imageURL)
            }
        }
    }
    
    
    private func url(forJewelId jewelId: String, forDealer dealerName: String) -> URL? {
        if let cachedURL = urlCache[jewelId] {
            return cachedURL
        }
        let imageFileName = AppDirectory.folder(forDealer: dealerName)
                                        .appendingPathComponent(jewelId)
        let fm = FileManager.default
        var imageFile = imageFileName.appendingPathExtension("jpg")
        if !fm.fileExists(atPath: imageFile.path) {
            imageFile = imageFileName.appendingPathExtension("jpeg")
        }
        if !fm.fileExists(atPath: imageFile.path) {
            return nil
        }
        urlCache[jewelId] = imageFile
        return imageFile
    }
}
