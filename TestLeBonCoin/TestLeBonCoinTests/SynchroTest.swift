//
//  SynchroTest.swift
//  TestLeBonCoinTests
//
//  Created by Damien on 25/09/2020.
//

import XCTest

class SynchroTest: XCTestCase {

    override func setUpWithError() throws {
        UserDefaults.standard.removeObject(forKey: "LAST_SYNCHRO_KEY")
        UserDefaults.standard.synchronize()

        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSynchro() throws {

        let testSynchroExpectation = expectation(description: "testSynchroExpectation")
        let synchro = SynchroManager<TestItem,TestCategory>()
        synchro.register(netWorkManager: TestNetWorkManager(), dao: TestDao())

        synchro.doSynchro(filteredByCategoryID: nil ) {(items, categories, error) in
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

    func testShouldDoSynchro() {
        let synchro = SynchroManager<TestItem,TestCategory>()
        synchro.register(netWorkManager: TestNetWorkManager(), dao: TestDao())
        XCTAssertTrue(synchro.shouldDoSynchro())
        synchro.doSynchro(filteredByCategoryID: nil ) { _,_,_ in
            //do nothing not the point Here
            // we call doSynchro in order to save lastSynchroDate
        }
        synchro.getTimeProvider().delay = 5
        XCTAssertFalse(synchro.shouldDoSynchro())

        synchro.getTimeProvider().delay = 30
        XCTAssertTrue(synchro.shouldDoSynchro())
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            try? testSynchro()
            // Put the code you want to measure the time of here.
        }
    }

}
