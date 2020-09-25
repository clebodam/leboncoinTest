//
//  Dao.swift
//  TestLeBonCoin
//
//  Created by Damien on 23/09/2020.
//

import Foundation

protocol DaoProtocol {

    func saveItemsData(items :[ItemProtocol])
    func getItemsData() -> [ItemProtocol]

    func saveCategoriesData(items :[CategoryProtocol])
    func getCategoriesData() -> [CategoryProtocol]
}

class Dao<I: ItemProtocol,C: CategoryProtocol> :DaoProtocol {
    fileprivate let daoItems = UnitDao<I>()
    fileprivate let daoCategories = UnitDao<C>()
    func saveItemsData(items: [ItemProtocol]) {
        if let items = items as? [I] {
            daoItems.saveData(items: items)
        }
    }

    func getItemsData() -> [ItemProtocol] {
        return daoItems.getData()
    }

    func saveCategoriesData(items: [CategoryProtocol]) {
        if let items = items as? [C] {
            daoCategories.saveData(items: items)
        }
    }

    func getCategoriesData() -> [CategoryProtocol] {
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
        let data = UserDefaults.standard.value(forKey: String(describing: T.self))
        if let result = try? JSONDecoder().decode([T].self, from: data as! Data)  {
            return result
        } else {
            return [T]()
        }
    }

}

