//
//  SynchroManager.swift
//  TestLeBonCoin
//
//  Created by Damien on 23/09/2020.
//

import Foundation

protocol SynchroProtocol {
    func doSynchro(_ completion: @escaping ([ItemProtocol],[CategoryProtocol]) -> ())
    func register(netWorkManager: NetWorkManagerProtocol, dao: DaoProtocol)
}

class SynchroManager<I:ItemProtocol,C:CategoryProtocol>: SynchroProtocol {

    typealias I = ItemProtocol
    typealias C = CategoryProtocol

    private  let SYNCHRO_DELAY_SECONDS = 20
    private  let LAST_SYNCHRO_KEY = "LAST_SYNCHRO_KEY"
    private var dao: DaoProtocol?
    private var netWorkManager: NetWorkManagerProtocol?

    private func lastSynchroDate() -> Date {
        return (UserDefaults.standard.value(forKey: LAST_SYNCHRO_KEY) as? Date) ?? Date(timeIntervalSince1970: 0)
    }

    private func saveLastSynchroDate() {
        UserDefaults.standard.setValue(Date(), forKey: LAST_SYNCHRO_KEY)
        UserDefaults.standard.synchronize()

    }

    private func shouldDoSynchro() -> Bool {
        return Date(timeIntervalSinceNow: TimeInterval(SYNCHRO_DELAY_SECONDS)) >= lastSynchroDate()
    }

    func doSynchro(_ completion: @escaping ([ItemProtocol],[CategoryProtocol]) -> ()) {
        if Reachability.isConnectedToNetwork() && shouldDoSynchro()  {
            // get new data, write it and use it
            netWorkManager?.getData { [weak self] in
                if let items = self?.dao?.getItemsData(),
                   let categories = self?.dao?.getCategoriesData() {
                    completion(items, categories)
                    self?.saveLastSynchroDate()
                }
            }
        } else {
            // return data from storage
            if  let items = self.dao?.getItemsData(),
                let categories = self.dao?.getCategoriesData() {
                completion(items, categories)
            }
        }
    }

    func register(netWorkManager: NetWorkManagerProtocol, dao: DaoProtocol) {
        self.netWorkManager = netWorkManager
        self.netWorkManager?.registerDao(dao)
        self.dao = dao
    }
}
