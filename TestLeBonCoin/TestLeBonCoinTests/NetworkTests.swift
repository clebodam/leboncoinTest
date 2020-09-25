//
//  NetworkTests.swift
//  TestLeBonCoinTests
//
//  Created by Damien on 25/09/2020.
//

import Foundation
import XCTest



class NetworkTests: XCTestCase {
    private let ITEMS_URL = "https://raw.githubusercontent.com/leboncoin/paperclip/master/listing.json"

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFailBadRoute() throws {
        let nwManager = NetWorkManager<TestItem,TestCategory>()
        let testFailExpectation = expectation(description: "testFailExpectation")

        nwManager.get([TestItem].self, route: "https://www.google.fr") { result in
            switch result {
            case .success:
               XCTAssertTrue(false)
            case .failure:
            XCTAssertTrue(true)
            }
            testFailExpectation.fulfill()
        }

        waitForExpectations(timeout: 5) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func testFailBadSerialization() throws {
        let nwManager = NetWorkManager<TestItem,TestCategory>()
        let testFailExpectation = expectation(description: "testFailExpectation")

        nwManager.get([Int].self, route: ITEMS_URL) { result in
            switch result {
            case .success:
               XCTAssertTrue(false)
            case .failure:
            XCTAssertTrue(true)
            }
            testFailExpectation.fulfill()
        }

        waitForExpectations(timeout: 5) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func testGoodUrLandGoodSerialization() throws {
        let nwManager = NetWorkManager<TestItem,TestCategory>()
        let testExpectation = expectation(description: "testExpectation")

        nwManager.get([TestItem].self, route: ITEMS_URL) { result in
            switch result {
            case .success:
               XCTAssertTrue(true)
            case .failure:
            XCTAssertTrue(false)
            }
            testExpectation.fulfill()
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
