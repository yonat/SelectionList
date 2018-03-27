//
//  ViewController.swift
//  SelectionListDemo
//
//  Created by Yonat Sharon on 27.03.2018.
//  Copyright © 2018 Yonat Sharon. All rights reserved.
//

import UIKit
import SelectionList

class ViewController: UIViewController {
    @IBOutlet var selectionList: SelectionList!

    override func viewDidLoad() {
        super.viewDidLoad()
        selectionList.items = ["One", "Two", "Three", "Four", "Five"]
        selectionList.selectedIndexes = [0, 1, 4]
        selectionList.addTarget(self, action: #selector(selectionChanged), for: .valueChanged)
        selectionList.setupCell = { (cell: UITableViewCell, index: Int) in
            cell.textLabel?.textColor = .gray
        }
    }

    @objc func selectionChanged() {
        print(selectionList.selectedIndexes)
    }
}

