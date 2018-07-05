//
//  FilterableTableViewController.swift
//  YCC App
//
//  Created by Vikram Raj Gopinathan on 05/07/18.
//  Copyright © 2018 Vikram Raj Gopinathan. All rights reserved.
//

import Cocoa
import RealmSwift

protocol ROSelectionViewControllerDelegate: class {
    associatedtype T: Object
    func modalWindowClosed()
    func selectionMade(_ item: ThreadSafeReference<T>)
}

protocol FilterableItem {
    var summary: String { get }
    
    func shouldSelect(for query: String) -> Bool
}

class ROSelectionViewController<T: FilterableItem,
                                D: ROSelectionViewControllerDelegate>:
                                NSViewController, NSTableViewDataSource,
                                NSTableViewDelegate, NSWindowDelegate,
                                NSSearchFieldDelegate
                                where D.T == T {
    
    var items: [T] = []
    private var filtered: [T] = []
    private var queryString: String = ""
    
    weak var delegate: D?
    
    let scrollView = NSScrollView()
    var tableView: NSTableView = {
        let table = NSTableView(frame: .zero)
        table.rowSizeStyle = .large
        table.usesAlternatingRowBackgroundColors = true
        
        let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "item"))
        table.headerView = nil
        column.width = 1.0
        table.addTableColumn(column)
        return table
    }()
    let searchField = NSSearchField(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filtered = items
        configSearchField()
        configTableView()
        tableView.reloadData()
    }
    
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
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return filtered.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let highlighted = filtered[row].summary.highlight(queryString)
        let view = NSTextField(labelWithAttributedString: highlighted)
        return view
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
