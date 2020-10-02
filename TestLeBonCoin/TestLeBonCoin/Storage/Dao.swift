//
//  Dao.swift
//  TestLeBonCoin
//
//  Created by Damien on 23/09/2020.
//

import Foundation
import UIKit
import CoreData

protocol DaoProtocol {
    func saveItemsData(items :[ItemProtocol])
    func getItemsData() -> [ItemProtocol]
    func getFilteredItems(byCategory: Int?,  completion: @escaping ([ItemProtocol]) -> ())
    func saveCategoriesData(items :[CategoryProtocol])
    func getCategoriesData() -> [CategoryProtocol]
    func reset()
}

class Dao<I: ItemProtocol,C: CategoryProtocol> :DaoProtocol {
    fileprivate let daoItems = UnitDao<I>()
    fileprivate let daoCategories = UnitDao<C>()
    private var useCoreData: Bool = true
    private let dataManager : CoreDataManager<I,C>

    init(persist:Bool  = true , useCoreData: Bool = true) {
        dataManager = CoreDataManager<I,C>(persist:persist)
        self.useCoreData = useCoreData
    }
    func saveItemsData(items: [ItemProtocol]) {
        
        if let items = items as? [I] {
            if useCoreData{
                dataManager.saveItemsInBase(items: items)
            } else {
                daoItems.saveData(items: items)
            }
        }
    }
    
    func reset() {
        if useCoreData {
            dataManager.deleteEntity(name: "ItemCoreData")
            dataManager.deleteEntity(name: "CategoryCoreData")
        } else {
            daoItems.reset()
            daoCategories.reset()
        }
    }

    func getItemsData() -> [ItemProtocol] {
        if useCoreData {
            return dataManager.getItemsInBase()
        }
        return daoItems.getData()
    }

    func getFilteredItems(byCategory: Int?,  completion: @escaping ([ItemProtocol]) -> ()) {

        if useCoreData {
            completion(dataManager.getItemsInBase(byId: byCategory))

        } else {
            var allItems = getItemsData()
            if let idToFilter = byCategory  {
                allItems = allItems.filter {
                    $0.getCategoryId() == idToFilter
                }
            }
            var sortedItems = [ItemProtocol] ()
            let urgentItems = allItems.filter {
                $0.isUrgent()
            }.sorted {
                $0.getCreationDate() ?? Date() > $1.getCreationDate() ?? Date()
            }
            let nonUrgentItems = allItems.filter {
                !$0.isUrgent()
            }.sorted {
                $0.getCreationDate() ?? Date() > $1.getCreationDate() ?? Date()
            }
            sortedItems.append(contentsOf: urgentItems)
            sortedItems.append(contentsOf: nonUrgentItems)
        completion(sortedItems)
        }
    }

    func saveCategoriesData(items: [CategoryProtocol]) {
        if let items = items as? [C] {
            if useCoreData {
                dataManager.saveCategoriesInBase(items: items)
            } else {
                daoCategories.saveData(items: items)
            }
        }
    }

    func getCategoriesData() -> [CategoryProtocol] {
        if useCoreData {
            return dataManager.getCategoriesInBase()
        }
        return daoCategories.getData()
    }


   
}


private class UnitDao<T:Codable>  {

    func saveData(items :[T]) {
        let userDefault =   UserDefaults.standard
        let data = try? JSONEncoder().encode(items)
        userDefault.setValue(data, forKey: String(describing: T.self))
        userDefault.synchronize()
    }

    func getData() -> [T] {
        if let data = UserDefaults.standard.value(forKey: String(describing: T.self)) {
            if let result = try? JSONDecoder().decode([T].self, from: data as! Data)  {
                return result
            } else {
                return [T]()
            }
        }
        return [T]()
    }

    func reset() {
        let userDefault =   UserDefaults.standard
        userDefault.removeObject(forKey: String(describing: T.self))
        userDefault.synchronize()
    }



}

