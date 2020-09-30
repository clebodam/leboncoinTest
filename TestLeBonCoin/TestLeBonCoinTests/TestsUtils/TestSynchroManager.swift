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
    var delayForTimeProvider = 0

    init() {
        register(netWorkManager: TestNetWorkManager(), dao: TestDao())
    }
    func doSynchro(filteredByCategoryID: Int?, _ completion: @escaping CompletionBlock) {
        let items = dao?.getItemsData() ?? [ItemProtocol]()
        let categories = dao?.getCategoriesData() ?? [CategoryProtocol]()
        completion(items,categories)
    }

    func register(netWorkManager: NetWorkManagerProtocol, dao: DaoProtocol) {
        self.dao = dao
        self.dao?.reset()
        self.netWorkManager = netWorkManager
    }

    func getTimeProvider() -> TimeProvider {
        return TimeProvider(TimeInterval(delayForTimeProvider))
    }


}
