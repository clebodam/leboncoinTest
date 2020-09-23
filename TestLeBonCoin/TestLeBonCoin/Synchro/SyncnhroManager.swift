//
//  SyncnhroManager.swift
//  TestLeBonCoin
//
//  Created by Damien on 23/09/2020.
//

import Foundation

class SyncnhroManager {
   public static let instance = SyncnhroManager()
    private let daoItems = Dao<Item>()
    private let daoCategories = Dao<Category>()
    private let networkManager: NetWorkManager

    init() {
        networkManager = NetWorkManager(daoItems: self.daoItems,daoCategories: self.daoCategories)
    }

    func doSynchro(_ completion: @escaping ([Item],[Category]) -> ()) {
        if Reachability.isConnectedToNetwork() {
            // get new data, write it and use it
            networkManager.getData {
                let items = Dao<Item>().getData()
                let categories = Dao<Category>().getData()
                completion(items, categories)
            }
        } else {
            // return data from storage
            let items = Dao<Item>().getData()
            let categories = Dao<Category>().getData()
            completion(items, categories)

        }
    }
}
