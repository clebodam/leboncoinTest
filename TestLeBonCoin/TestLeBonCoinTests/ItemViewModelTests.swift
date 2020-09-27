//
//  ItemViewModelTests.swift
//  TestLeBonCoinTests
//
//  Created by Damien on 27/09/2020.
//

import XCTest

class ItemViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInit() throws {
        let rawCat = TestCategory()
        let rawItem = TestItem()
        let catViewModel = CategoryViewModel(rawCat)
        let itemViewModel = ItemViewModel(rawItem, catViewModel)
        XCTAssertTrue(rawCat.getId() == itemViewModel.category.id)
        XCTAssertTrue(rawCat.getName() == itemViewModel.category.name)
        XCTAssertTrue(rawItem.getId() == itemViewModel.id)
        XCTAssertTrue(rawItem.getDescription() == itemViewModel.description)
        XCTAssertTrue(rawItem.getTitle() == itemViewModel.title)
        XCTAssertTrue(rawItem.getPrice() == itemViewModel.price)
        XCTAssertTrue(rawItem.isUrgent() == itemViewModel.isUrgent)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
