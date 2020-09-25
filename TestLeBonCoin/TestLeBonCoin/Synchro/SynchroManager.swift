//
//  SynchroManager.swift
//  TestLeBonCoin
//
//  Created by Damien on 23/09/2020.
//

import Foundation

protocol SynchroProtocol {
    var dao: DaoProtocol? { get set }
    var netWorkManager: NetWorkManagerProtocol? { get set }
    func doSynchro(_ completion: @escaping ([ItemProtocol],[CategoryProtocol]) -> ())
    func register(netWorkManager: NetWorkManagerProtocol, dao: DaoProtocol)
}

class SynchroManager<I:ItemProtocol,C:CategoryProtocol>: SynchroProtocol {

    typealias I = ItemProtocol
    typealias C = CategoryProtocol

    private  let SYNCHRO_DELAY_SECONDS = 20
    private  let LAST_SYNCHRO_KEY = "LAST_SYNCHRO_KEY"
    internal var dao: DaoProtocol?
    internal var netWorkManager: NetWorkManagerProtocol?

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
            netWorkManager?.getData { [weak self]  items , categories in
                self?.dao?.saveItemsData(items: items)
                self?.dao?.saveCategoriesData(items: categories)
                completion(items, categories)
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
        self.dao = dao
    }
}
