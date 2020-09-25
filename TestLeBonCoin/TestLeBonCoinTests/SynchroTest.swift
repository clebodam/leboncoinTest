//
//  SynchroTest.swift
//  TestLeBonCoinTests
//
//  Created by Damien on 25/09/2020.
//

import XCTest

class SynchroTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSynchro() throws {

        let testSynchroExpectation = expectation(description: "testSynchroExpectation")
        let synchro = SynchroManager<TestItem,TestCategory>()
        synchro.register(netWorkManager: TestNetWorkManager(), dao: TestDao())

        synchro.doSynchro { (items, categories) in
            XCTAssertTrue(items.count == 100)
            XCTAssertTrue(categories.count == 20)
            testSynchroExpectation.fulfill()

        }

        waitForExpectations(timeout: 5) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
