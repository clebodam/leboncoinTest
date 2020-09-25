//
//  DaoTests.swift
//  TestLeBonCoinTests
//
//  Created by Damien on 25/09/2020.
//

import XCTest

class DaoTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSaveAndRead() throws {
        let categoriesCount = 20
        let itemsCount = 100
        let dao = Dao<TestItem,TestCategory>()
        let items:[TestItem] = (0..<itemsCount).indices.map { _ in TestItem()}
        let categories:[TestCategory] = (0..<categoriesCount).indices.map { _ in TestCategory()}
        dao.saveItemsData(items: items)
        dao.saveCategoriesData(items: categories)
        XCTAssertTrue(dao.getItemsData().count == itemsCount)
        XCTAssertTrue(dao.getCategoriesData().count == categoriesCount)

    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
