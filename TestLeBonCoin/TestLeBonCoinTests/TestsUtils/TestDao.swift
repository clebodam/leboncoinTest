//
//  TestDao.swift
//  TestLeBonCoinTests
//
//  Created by Damien on 25/09/2020.
//

import Foundation

class TestDao:DaoProtocol {



    let items:[TestItem]
    let categories:[TestCategory]
    init() {
        let categoriesCount = 20
        let itemsCount = 100
        self.items = (0..<itemsCount).indices.map { _ in TestItem()}
        self.categories = (0..<categoriesCount).indices.map { _ in TestCategory()}
    }

    func getFilteredItems(byCategory: Int?, completion: @escaping ([ItemProtocol]) -> ()) {
        completion(self.items)
    }

    func saveItemsData(items: [ItemProtocol]) {
        // do nothing
    }

    func getItemsData() -> [ItemProtocol] {
        return  self.items
    }

    func saveCategoriesData(items: [CategoryProtocol]) {
        //do Nothing
    }

    func getCategoriesData() -> [CategoryProtocol] {
       return  self.categories
    }

    func reset() {
        // do Nothing
    }





}
