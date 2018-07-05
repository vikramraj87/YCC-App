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

class FilterableTableViewController: NSViewController {
    var items: [FilterableItem] = []
    private var filtered: [FilterableItem] = []
    
    private var queryString: String = ""
    
    @IBOutlet var tableView: NSTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let realm = try? Realm() else {
            print("Not able to fetch Realm instance")
            return
        }
        items = Array(realm.objects(RODealer.self).sorted(byKeyPath: "name"))
        filtered = items
        tableView.dataSource = self
        tableView.delegate = self
        tableView.usesAlternatingRowBackgroundColors = true
        tableView.rowSizeStyle = .large
        tableView.reloadData()
    }
    
}

extension FilterableTableViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return filtered.count
    }
}

extension FilterableTableViewController: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let columnIdentifier = tableColumn?.identifier,
            let view = tableView.makeView(withIdentifier: columnIdentifier, owner: self),
            let cellView = view as? NSTableCellView else {
                return nil
        }
        let highlighted = highlightedSummary(forSummary: filtered[row].summary)
        cellView.textField?.attributedStringValue = highlighted
        return cellView
    }
    
    private func highlightedSummary(forSummary summary: String) -> NSAttributedString {
        let attributed = NSMutableAttributedString(string: summary)
        guard !queryString.isEmpty,
            let highlightRange = summary.uppercased().range(of: queryString.uppercased())
        else {
            return attributed
        }
        
        attributed.addAttribute(NSAttributedStringKey.backgroundColor,
                                value: NSColor.systemYellow,
                                range: NSRange(highlightRange, in: summary))
        
        return attributed
    }
}

extension FilterableTableViewController: NSSearchFieldDelegate {
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
