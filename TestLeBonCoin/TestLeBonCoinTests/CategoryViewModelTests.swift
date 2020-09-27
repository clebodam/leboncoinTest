//
//  CategoryViewModelTests.swift
//  TestLeBonCoinTests
//
//  Created by Damien on 27/09/2020.
//

import XCTest

class CategoryViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInit() throws {
        let rawCategory = TestCategory()
        let catViewModel = CategoryViewModel(rawCategory)
        XCTAssertTrue(rawCategory.getName() == catViewModel.name)
        XCTAssertTrue(rawCategory.getId() == catViewModel.id)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
