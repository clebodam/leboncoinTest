//
//  ViewModelTests.swift
//  TestLeBonCoinTests
//
//  Created by Damien on 25/09/2020.
//

import XCTest

class ViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTreatment() throws {
        let viewModel = ListTableViewViewModel<TestItem,TestCategory>()
        let synchro = TestSynchroManager()
        viewModel.register(synchroManager: synchro, dao: TestDao(), networkManager: TestNetWorkManager())
        let testTreatmentExpectation = expectation(description: "testTreatment")
        viewModel.getData { (items, categories) in
            XCTAssertTrue(items.count >= 0 )
            XCTAssertTrue(categories.count >= 0)
            testTreatmentExpectation.fulfill()
        }

        waitForExpectations(timeout: 5) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func testPopulate() throws {
        let viewModel = ListTableViewViewModel<TestItem,TestCategory>()
        let items = TestDao().getItemsData()
        let categories = TestDao().getCategoriesData()
        _ = viewModel.populate(items, categories)
        /* les valeurs doivent être inférieurs car cela est du à la fçon dont sont générées les TestItems et les TestCategories
         en effet les id sont complètements random donc il se peut que qoit généré un Item avec une categorie_id qui n exite pas  du coup on ne crée pas l'item
         */
        XCTAssertTrue(viewModel.filteredItems.value.count <= 100)
        if let categoriesVM = viewModel.getCategories() {
            XCTAssertTrue(categoriesVM.count  <= 20)
        }
    }

    func testfilter() {
        let viewModel = ListTableViewViewModel<TestItem,TestCategory>()
        let urgentItems = TestItem.createItems(urgent: true, count: 20, categoriesCount: 20)
        let nonUrgentitems = TestItem.createItems(urgent: false, count: 80, categoriesCount: 20)
        let categories = TestCategory.createUniqCategories(count: 20)

        var allItems = [TestItem]()
        allItems.append(contentsOf: urgentItems)
        allItems.append(contentsOf: nonUrgentitems)
        allItems.shuffle()
        let filteredItem: [ItemViewModel] = viewModel.populateAndFilter(allItems, categories)
        var lastItem: ItemViewModel? = nil
        for  i  in 0...100 {
            if i == 21 {
                lastItem = nil
            }
            let item = filteredItem[i]
            if i <= 20 {
                XCTAssertTrue(item.isUrgent)
            } else {
                XCTAssertFalse(item.isUrgent)
            }
            if let lastItemDate = lastItem?.creation_date, let itemDate =   item.creation_date{
                XCTAssertTrue( itemDate <= lastItemDate)
            }
            lastItem = item
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        let viewModel = ListTableViewViewModel<TestItem,TestCategory>()
        let items = TestDao().getItemsData()
        let categories = TestDao().getCategoriesData()

        self.measure {
            _ = viewModel.populateAndFilter(items, categories)
        }
    }

}
