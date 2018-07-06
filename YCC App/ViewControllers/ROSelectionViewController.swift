//
//  FilterableTableViewController.swift
//  YCC App
//
//  Created by Vikram Raj Gopinathan on 05/07/18.
//  Copyright © 2018 Vikram Raj Gopinathan. All rights reserved.
//

import Cocoa
import RealmSwift

protocol FilterableItem {
    var summary: String { get }
    func shouldSelect(for query: String) -> Bool
}

protocol ROSelectionViewControllerDelegate: class {
    associatedtype T: Object
    func modalWindowClosed()
    func selectionMade(_ itemRef: ThreadSafeReference<T>)
}

class ROSelectionViewController
    <T: FilterableItem, D: ROSelectionViewControllerDelegate>:
        NSViewController, NSTableViewDataSource,
        NSTableViewDelegate, NSWindowDelegate,
        NSSearchFieldDelegate
            where D.T == T {
    
    var items: [T] = []
    private var filtered: [T] = []
    private var queryString: String = ""
    
    weak var delegate: D?
    
    let scrollView = NSScrollView()
    var tableView: NSTableView = NSTableView(frame: .zero)
    let searchField = NSSearchField(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filtered = items
        configSearchField()
        configTableView()
        tableView.reloadData()
    }
    
    // Create and layout views
    override func loadView() {
        let rect = NSRect(x: 0, y: 0, width: 400, height: 300)
        view = NSView(frame: rect)
    }
    
    private func configSearchField() {
        searchField.delegate = self
        
        searchField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchField)
        
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: view.topAnchor),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func configTableView() {
        scrollView.documentView = tableView
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: searchField.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.rowSizeStyle = .large
        tableView.usesAlternatingRowBackgroundColors = true
        
        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "item"))
        tableView.headerView = nil
        column.width = 1.0
        tableView.addTableColumn(column)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return filtered.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let highlighted = filtered[row].summary.highlight(queryString)
        let bgView = NSView(frame: .zero)
        let lbl = NSTextField(labelWithAttributedString: highlighted)
        bgView.addSubview(lbl)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lbl.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 8.0),
            lbl.centerYAnchor.constraint(equalTo: bgView.centerYAnchor)
        ])
        
        return bgView
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let selectedRow = tableView.selectedRow
        guard selectedRow != -1 else { return }
        let item = filtered[selectedRow]
        let threadSafeRef = ThreadSafeReference(to: item)
        delegate?.selectionMade(threadSafeRef)
        dismiss(self)
    }
    
    func windowWillClose(_ notification: Notification) {
        delegate?.modalWindowClosed()
    }
    
    override func controlTextDidChange(_ obj: Notification) {
        guard let searchField = obj.object as? NSSearchField else {
            return
        }
        defer {
            tableView.reloadData()
        }
        queryString = searchField.stringValue
        if queryString.isEmpty {
            filtered = items
            return
        }
        filtered = items.filter { filterableItem in
            return filterableItem.shouldSelect(for: queryString)
        }
    }

}
