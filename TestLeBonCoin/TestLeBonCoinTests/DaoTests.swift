//
//  DaoTests.swift
//  TestLeBonCoinTests
//
//  Created by Damien on 25/09/2020.
//

import XCTest

class DaoTests: XCTestCase {
    var  dao = Dao<TestItem,TestCategory> ()
    override func setUpWithError() throws {
        dao.setUseCoredata(false)
        dao.reset()
        // Can't test CoreData storage I can't read  the datamodel from the unit test target
        // Don't have time to investigate why

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSaveAndRead() throws {
        let categoriesCount = 20
        let itemsCount = 1000
        let items:[TestItem] = (0..<itemsCount).indices.map { _ in TestItem()}
        let categories:[TestCategory] = (0..<categoriesCount).indices.map { _ in TestCategory()}
        dao.saveItemsData(items: items)
        dao.saveCategoriesData(items: categories)
        XCTAssertTrue(dao.getItemsData().count == itemsCount)
        XCTAssertTrue(dao.getCategoriesData().count == categoriesCount)
    }

    func testReset() throws {
        let categoriesCount = 20
        let itemsCount = 1000
        let items:[TestItem] = (0..<itemsCount).indices.map { _ in TestItem()}
        let categories:[TestCategory] = (0..<categoriesCount).indices.map { _ in TestCategory()}
        dao.saveItemsData(items: items)
        dao.saveCategoriesData(items: categories)
        dao.reset()
        XCTAssertTrue(dao.getItemsData().count == 0)
        XCTAssertTrue(dao.getCategoriesData().count == 0)

    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
           try? testSaveAndRead()
            // Put the code you want to measure the time of here.
        }
    }

}
