//
//  SelectionListDemoUITests.swift
//  SelectionListDemoUITests
//
//  Created by Yonat Sharon on 26.05.2018.
//  Copyright © 2018 Yonat Sharon. All rights reserved.
//

import XCTest

class SelectionListDemoUITests: XCTestCase {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    func testSeletion() {
        let app = XCUIApplication()
        let selectionList = app.tables.firstMatch

        XCTAssert(selectionList.cells.element(boundBy: 1).isSelected)
        XCTAssert(!selectionList.cells.element(boundBy: 3).isSelected)
        XCTAssert(selectionList.cells.element(boundBy: 4).isSelected)

        let firstCell = selectionList.cells.element(boundBy: 0)
        XCTAssert(firstCell.isSelected)
        firstCell.tap()
        XCTAssert(!firstCell.isSelected)

        let thirdCell = selectionList.cells.element(boundBy: 2)
        XCTAssert(!thirdCell.isSelected)
        thirdCell.tap()
        XCTAssert(thirdCell.isSelected)
    }
}
