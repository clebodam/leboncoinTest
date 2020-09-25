//
//  TestCategory.swift
//  TestLeBonCoinTests
//
//  Created by Damien on 25/09/2020.
//

import Foundation

class TestCategory: CategoryProtocol {
    func getName() -> String {
        return "name of \(getId())"
    }

    func getId() -> Int {
        return Int.random(in: 1...20)
    }


}
