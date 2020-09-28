//
//  TestLeBonCoinUITests.swift
//  TestLeBonCoinUITests
//
//  Created by Damien on 22/09/2020.
//

import XCTest

class TestLeBonCoinUITests: XCTestCase {


    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    func testTableCellSelectionAndBack() {
        let app = XCUIApplication()
        app.launch()
        let articleTableView = app.tables["tableView"].firstMatch
        XCTAssertNotNil(articleTableView)
        XCTAssert( articleTableView.cells.firstMatch.exists)
        articleTableView.cells.firstMatch.tap()
        app.navigationBars.buttons.firstMatch.tap()
    }

    func testTableFilter() {
        let app = XCUIApplication()
        app.launch()
        XCTAssert( app.navigationBars.firstMatch.buttons["filter"].exists)
        app.navigationBars.firstMatch.buttons["filter"].tap()
    }

    func testTableReload() {
        let app = XCUIApplication()
        app.launch()
        XCTAssert( app.navigationBars.firstMatch.buttons["reload"].exists)
        app.navigationBars.firstMatch.buttons["reload"].tap()
    }


    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
