//
//  TestSynchroManager.swift
//  TestLeBonCoinTests
//
//  Created by Damien on 25/09/2020.
//

import Foundation


class TestSynchroManager: SynchroProtocol {
    var dao: DaoProtocol?

    var netWorkManager: NetWorkManagerProtocol?


    init() {
        register(netWorkManager: TestNetWorkManager(), dao: TestDao())
    }
    func doSynchro(_ completion: @escaping ([ItemProtocol], [CategoryProtocol]) -> ()) {
        let items = dao?.getItemsData() ?? [ItemProtocol]()
        let categories = dao?.getCategoriesData() ?? [CategoryProtocol]()
        completion(items,categories)
    }

    func register(netWorkManager: NetWorkManagerProtocol, dao: DaoProtocol) {
        self.dao = dao
        self.netWorkManager = netWorkManager
    }


}
