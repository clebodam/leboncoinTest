//
//  ListTableViewViewModel.swift
//  TestLeBonCoin
//
//  Created by Damien on 22/09/2020.
//

import Foundation

class ListTableViewViewModel {
    var categories: [CategoryViewModel]?
    var filterCategory: CategoryViewModel?
    private var items = [ItemViewModel]()
    var filteredItems: Dynamic<[ItemViewModel]> = Dynamic([ItemViewModel]())

    init() {
        populate()
    }
    
    func filter() {
        guard let filterCategory = filterCategory else {
            filteredItems.value = items
            return
        }
       filteredItems.value = items.filter {
            $0.category == filterCategory
        }
    }

    func populate() {
        for i in 0...10 {
            let category = CategoryViewModel(name :"category : \(i%3)",id: "\(i%3)")
            let item = ItemViewModel(title: "item : \(i)", description: "description : \(i)", id: "\(i)", category: category)
            items.append(item)
        }
        filteredItems.value = items
        categories =  Array(Set(self.items.map {$0.category})).sorted {
            $0.id < $1.id }
    }

    func getCategories() -> [CategoryViewModel]? {
        return categories
    }

}
