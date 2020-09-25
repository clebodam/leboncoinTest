//
//  TestNetWorkManager.swift
//  TestLeBonCoinTests
//
//  Created by Damien on 25/09/2020.
//

import Foundation

class TestNetWorkManager:NetWorkManagerProtocol {
    // GROSSE ANARQUE ! 
    func getData(completion: @escaping ([ItemProtocol], [CategoryProtocol]) -> ()) {
        let dao = TestDao()
        completion(dao.getItemsData(),dao.getCategoriesData())
    }


}
