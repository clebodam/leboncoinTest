//
//  SyncnhroManager.swift
//  TestLeBonCoin
//
//  Created by Damien on 23/09/2020.
//

import Foundation

class SyncnhroManager {
    public static let instance = SyncnhroManager()
    private static let SYNCHRO_DELAY_SECONDS = 20
    private static let LAST_SYNCHRO_KEY = "LAST_SYNCHRO_KEY"
    private let daoItems = Dao<Item>()
    private let daoCategories = Dao<Category>()
    private let networkManager: NetWorkManager

    init() {
        networkManager = NetWorkManager(daoItems: self.daoItems,daoCategories: self.daoCategories)
    }

    func lastSynchroDate() -> Date {
        return (UserDefaults.standard.value(forKey: SyncnhroManager.LAST_SYNCHRO_KEY) as? Date) ?? Date(timeIntervalSince1970: 0)
    }

    func saveLastSynchroDate() {
        UserDefaults.standard.setValue(Date(), forKey: SyncnhroManager.LAST_SYNCHRO_KEY)
        UserDefaults.standard.synchronize()

    }

    func shouldDoSynchro() -> Bool {
        return Date(timeIntervalSinceNow: TimeInterval(SyncnhroManager.SYNCHRO_DELAY_SECONDS)) >= lastSynchroDate()
    }

    func doSynchro(_ completion: @escaping ([Item],[Category]) -> ()) {
        if Reachability.isConnectedToNetwork() && shouldDoSynchro()  {
            // get new data, write it and use it
            networkManager.getData { [weak self] in
                let items = Dao<Item>().getData()
                let categories = Dao<Category>().getData()
                completion(items, categories)
                self?.saveLastSynchroDate()
            }
        } else {
            // return data from storage
            let items = Dao<Item>().getData()
            let categories = Dao<Category>().getData()
            completion(items, categories)

        }
    }
}
