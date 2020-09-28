//
//  TestCategory.swift
//  TestLeBonCoinTests
//
//  Created by Damien on 25/09/2020.
//

import Foundation

class TestCategory: CategoryProtocol {
    private var id: Int
    private var name: String
    init() {
        id = Int.random(in: 0..<20)
        name = "name of \(id)"
    }
    func getName() -> String {
        return name
    }

    func getId() -> Int {
        return id
    }

    init(id:Int) {
        self.id = id
        name = "name of \(id)"
    }
    
    required init(id: Int, name: String) {
        self.id = id
        self.name = name
    }

    static func createUniqCategories(count:Int) -> [TestCategory] {
        var categories = [TestCategory]()
        for i in 0...20 {
            let cat = TestCategory(id:i)
            categories.append(cat)
        }
        return categories
    }


}
