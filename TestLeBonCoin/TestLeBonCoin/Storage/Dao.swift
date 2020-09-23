//
//  Dao.swift
//  TestLeBonCoin
//
//  Created by Damien on 23/09/2020.
//

import Foundation

protocol DaoProtocol {
    associatedtype Entity
    func saveData(items :[Entity])
    func getData() -> [Entity]
}

class Dao<T:Codable>: DaoProtocol  {
    typealias Entity = T
    func saveData(items :[Entity]) {
        let userDefault =   UserDefaults.standard
        let data = try? JSONEncoder().encode(items)
        userDefault.setValue(data, forKey: String(describing: Entity.self))
        userDefault.synchronize()
    }

    func getData() -> [Entity] {
        let data = UserDefaults.standard.value(forKey: String(describing: Entity.self))
        if let result = try? JSONDecoder().decode([Entity].self, from: data as! Data)  {
            return result
        } else {
            return [Entity]()
        }
    }

}

