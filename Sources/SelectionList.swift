//
//  SelectionList.swift
//
//  Created by Yonat Sharon on 14.01.2018.
//  Copyright © 2018 Yonat Sharon. All rights reserved.
//

import UIKit

/// Simple single-selection or multiple-selection view, based on UITableView
@IBDesignable open class SelectionList: UIControl {
    public var tableView = UITableView()

    /// if `nil`, uses the standard checkmark accessory
    @IBInspectable open var selectionImage: UIImage? {
        didSet {
            updateMarks()
        }
    }

    @IBInspectable open var deselectionImage: UIImage? {
        didSet {
            updateMarks()
        }
    }

    /// if `false`, must have a `selectionImage`
    @IBInspectable open var isSelectionMarkTrailing: Bool = true {
        didSet {
            updateMarks()
        }
    }

    @IBInspectable open var allowsMultipleSelection: Bool {
        get {
            return tableView.allowsMultipleSelection
        }
        set {
            tableView.allowsMultipleSelection = newValue
        }
    }

    @IBInspectable open var rowHeight: CGFloat {
        get {
            return tableView.rowHeight
        }
        set {
            tableView.rowHeight = newValue
        }
    }

    /// the possible options to select
    open var items: [String] = [] {
        didSet {
            if items.count != oldValue.count {
                let prevSelectedIndexPaths = tableView.indexPathsForSelectedRows?.filter { $0.row < items.count } ?? []
                tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                invalidateIntrinsicContentSize()
                tableView.selectRows(at: prevSelectedIndexPaths)
            }
            else {
                for indexPath in tableView.indexPathsForVisibleRows ?? [] {
                    tableView.cellForRow(at: indexPath)?.textLabel?.text = items[indexPath.row]
                }
            }
        }
    }

    open var selectedIndex: Int? {
        get {
            return tableView.indexPathForSelectedRow?.row
        }
        set {
            tableView.deselectRows(at: tableView.indexPathsForSelectedRows?.filter { $0.row != selectedIndex } ?? [])
            if let selectedIndex = newValue {
                tableView.selectRow(at: IndexPath(row: selectedIndex, section: 0), animated: true, scrollPosition: .none)
            }
        }
    }

    open var selectedIndexes: [Int] {
        get {
            return tableView.indexPathsForSelectedRows?.map { $0.row } ?? []
        }
        set {
            tableView.deselectRows(at: tableView.indexPathsForSelectedRows?.filter { newValue.contains($0.row) } ?? [])
            let newIndexPathsToSelect = newValue
                .map { IndexPath(row: $0, section: 0) }
                .filter { !(tableView.indexPathsForSelectedRows?.contains($0) ?? false) }
            tableView.selectRows(at: newIndexPathsToSelect, animated: true)
        }
    }

    /// additional styling for the cell
    open var setupCell: ((UITableViewCell, Int) -> Void)? {
        didSet {
            for indexPath in tableView.indexPathsForVisibleRows ?? [] {
                guard let cell = tableView.cellForRow(at: indexPath) else { continue }
                setupCell?(cell, indexPath.row)
            }
        }
    }

    override open var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: tableView.contentSize.height)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    open override func prepareForInterfaceBuilder() {
        items = ["One", "Two", "Three"]
        selectedIndex = 2
    }

    private let reuseIdentifier = String(describing: SelectionListCell.self)
}

extension SelectionList {
    func setup() {
        tableView.register(SelectionListCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = bounds
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(tableView)
    }

    func updateMarks() {
        for indexPath in tableView.indexPathsForVisibleRows ?? [] {
            guard let cell = tableView.cellForRow(at: indexPath) else { continue }
            mark(cell: cell, selected: tableView.indexPathsForVisibleRows?.contains(indexPath) ?? false)
        }
    }

    func mark(cell: UITableViewCell, selected: Bool) {
        if let selectionImage = selectionImage {
            if isSelectionMarkTrailing {
                if selected {
                    cell.accessoryView = UIImageView(image: selectionImage)
                }
                else {
                    if let deselectionImage = deselectionImage {
                        cell.accessoryView = UIImageView(image: deselectionImage)
                    }
                    else {
                        cell.accessoryView = nil
                    }
                }
            }
            else {
                if selected {
                    cell.imageView?.image = selectionImage
                }
                else {
                    if let deselectionImage = deselectionImage {
                        cell.imageView?.image = deselectionImage
                    }
                    else {
                        cell.imageView?.image = UIImage.emptyImage(with: selectionImage.size)
                    }
                }
            }
        }
        else {
            cell.accessoryType = selected ? .checkmark : .none
        }
    }
}

extension SelectionList: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = items[indexPath.row]
        setupCell?(cell, indexPath.row)
        mark(cell: cell, selected: tableView.indexPathsForSelectedRows?.contains(indexPath) ?? false)
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        mark(cell: cell, selected: true)
        sendActions(for: .valueChanged)
    }

    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        mark(cell: cell, selected: false)
        sendActions(for: .valueChanged)
    }
}

class SelectionListCell: UITableViewCell {
    private var imageViewOriginX = CGFloat(0)

    override func layoutSubviews() {
        super.layoutSubviews();
        guard var imageViewFrame = imageView?.frame else { return }

        // re-entrance guard
        if 0 == imageViewOriginX {
            imageViewOriginX = imageViewFrame.origin.x
        }

        imageViewFrame.origin.x = imageViewOriginX + CGFloat(indentationLevel) * indentationWidth
        imageView?.frame = imageViewFrame
    }
}

extension UIImage {
    static func emptyImage(with size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UITableView {
    func selectRows(at indexPaths: [IndexPath], animated: Bool = false) {
        for indexPath in indexPaths {
            selectRow(at: indexPath, animated: animated, scrollPosition: .none)
        }
    }

    func deselectRows(at indexPaths: [IndexPath], animated: Bool = false) {
        for indexPath in indexPaths {
            deselectRow(at: indexPath, animated: animated)
        }
    }

}

