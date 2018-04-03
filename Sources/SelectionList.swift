//
//  SelectionList.swift
//
//  Created by Yonat Sharon on 14.01.2018.
//  Copyright © 2018 Yonat Sharon. All rights reserved.
//

import UIKit

/// Simple single-selection or multiple-selection checklist, based on UITableView
@IBDesignable open class SelectionList: UIControl {

    // MARK: - Public

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
            tableView.estimatedRowHeight = newValue
            invalidateIntrinsicContentSize()
        }
    }

    /// the possible options to select
    open var items: [String] = [] {
        didSet {
            deselectAll()
            tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            invalidateIntrinsicContentSize()
        }
    }

    open var selectedIndex: Int? {
        get {
            return tableView.indexPathForSelectedRow?.row
        }
        set {
            selectedIndexes = [newValue].compactMap { $0 }
        }
    }

    open var selectedIndexes: [Int] {
        get {
            return tableView.indexPathsForSelectedRows?.map { $0.row } ?? []
        }
        set {
            deselectAll()
            let indexPathsToSelect = newValue.map { IndexPath(row: $0, section: 0) }
            self.tableView.selectRows(at: indexPathsToSelect, animated: true)
            updateMarks()
        }
    }

    public private(set) var lastChangedIndex: Int? = nil

    /// additional styling for the cell
    open var setupCell: ((UITableViewCell, Int) -> Void)? {
        didSet {
            for indexPath in tableView.indexPathsForVisibleRows ?? [] {
                guard let cell = tableView.cellForRow(at: indexPath) else { continue }
                setupCell?(cell, indexPath.row)
            }
        }
    }

    // MARK: - Overrides

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

    // MARK: - Private

    let reuseIdentifier = String(describing: SelectionListCell.self)
}

extension SelectionList {
    func setup() {
        tableView.register(SelectionListCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = bounds
        tableView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(tableView)
        invalidateIntrinsicContentSize()
    }

    func deselectAll() {
        if let selectedIndexPaths = tableView.indexPathsForSelectedRows {
            tableView.deselectRows(at: selectedIndexPaths)
        }
    }

    func updateMarks() {
        for indexPath in tableView.indexPathsForVisibleRows ?? [] {
            guard let cell = tableView.cellForRow(at: indexPath) as? SelectionListCell else { continue }
            cell.updateSelectionAppearance()
        }
    }
}

// MARK: - UITableView DataSource & Delegate

extension SelectionList: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.selectionStyle = .none
        if let cell = cell as? SelectionListCell {
            cell.selectionImage = selectionImage
            cell.deselectionImage = deselectionImage
            cell.isSelectionMarkTrailing = isSelectionMarkTrailing
        }
        cell.textLabel?.text = items[indexPath.row]
        setupCell?(cell, indexPath.row)
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lastChangedIndex = indexPath.row
        sendActions(for: .valueChanged)
    }

    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        lastChangedIndex = indexPath.row
        sendActions(for: .valueChanged)
    }
}

// MARK: - Selection Marks

class SelectionListCell: UITableViewCell {
    var selectionImage: UIImage?
    var deselectionImage: UIImage?
    var isSelectionMarkTrailing: Bool = true

    func updateSelectionAppearance() {
        if let selectionImage = selectionImage {
            if isSelectionMarkTrailing {
                if isSelected {
                    accessoryView = UIImageView(image: selectionImage)
                }
                else {
                    if let deselectionImage = deselectionImage {
                        accessoryView = UIImageView(image: deselectionImage)
                    }
                    else {
                        accessoryView = nil
                    }
                }
            }
            else {
                if isSelected {
                    imageView?.image = selectionImage
                }
                else {
                    if let deselectionImage = deselectionImage {
                        imageView?.image = deselectionImage
                    }
                    else {
                        imageView?.image = UIImage.emptyImage(size: selectionImage.size)
                    }
                }
            }
        }
        else {
            accessoryType = isSelected ? .checkmark : .none
        }
    }

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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        updateSelectionAppearance()
    }

    override var isSelected: Bool {
        didSet {
            updateSelectionAppearance()
        }
    }

    override func prepareForReuse() {
        updateSelectionAppearance()
    }
}

// MARK: - Handy Extensions

extension UIImage {
    static func emptyImage(size: CGSize) -> UIImage? {
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

