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
    func doSynchro(_ completion: @escaping CompletionBlock)
    func register(netWorkManager: NetWorkManagerProtocol, dao: DaoProtocol)
    func getTimeProvider() -> TimeProvider
}

class TimeProvider {

    var delay = TimeInterval(0)
    init(_ delay: TimeInterval) {
        self.delay = delay
    }

    func now() -> Date {
        return Date().addingTimeInterval(delay)
    }

}

class SynchroManager<I:ItemProtocol,C:CategoryProtocol>: SynchroProtocol {

    typealias I = ItemProtocol
    typealias C = CategoryProtocol

    private  let SYNCHRO_DELAY_SECONDS = 20
    private  let LAST_SYNCHRO_KEY = "LAST_SYNCHRO_KEY"
    private let timeProvider = TimeProvider(0)
    internal var dao: DaoProtocol?
    internal var netWorkManager: NetWorkManagerProtocol?

    private func lastSynchroDate() -> Date {
        return (UserDefaults.standard.value(forKey: LAST_SYNCHRO_KEY) as? Date) ?? Date(timeIntervalSince1970: 0)
    }

    private func saveLastSynchroDate() {
        UserDefaults.standard.setValue(getTimeProvider().now(), forKey: LAST_SYNCHRO_KEY)
        UserDefaults.standard.synchronize()
    }

    func shouldDoSynchro() -> Bool {
        return lastSynchroDate().addingTimeInterval(TimeInterval(SYNCHRO_DELAY_SECONDS)) <= getTimeProvider().now()
    }
    
    func doSynchro(_ completion: @escaping CompletionBlock) {
        if Reachability.isConnectedToNetwork() && shouldDoSynchro()  {
            // get new data, write it and use it
            netWorkManager?.getData { [weak self]  items , categories in
                // we can  do a reset to remove all entities
                // this is the easier synchronisation strategy
               // self?.dao?.reset()
                
                self?.dao?.saveItemsData(items: items)
                self?.dao?.saveCategoriesData(items: categories)
                print("SynchroManager - data from network \(items.count) items")
                completion(items, categories)
                self?.saveLastSynchroDate()
            }
        } else {
            // return data from storage
            if  let items = self.dao?.getItemsData(),
                let categories = self.dao?.getCategoriesData() {
                completion(items, categories)
                print("SynchroManager - data from storage \(items.count) items")
            }
        }
    }

    func register(netWorkManager: NetWorkManagerProtocol, dao: DaoProtocol) {
        self.netWorkManager = netWorkManager
        self.dao = dao
    }

    func getTimeProvider() -> TimeProvider {
        return timeProvider
    }

}
