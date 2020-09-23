//
//  ListTableViewViewModel.swift
//  TestLeBonCoin
//
//  Created by Damien on 22/09/2020.
//

import Foundation

class ListTableViewViewModel {
    var categories: [CategoryViewModel] =  [CategoryViewModel]()
    var filterCategory: CategoryViewModel?
    private var items = [ItemViewModel]()
    var filteredItems: Dynamic<[ItemViewModel]> = Dynamic([ItemViewModel]())

    func filter() {
        guard let filterCategory = filterCategory else {
            filteredItems.value = items
            return
        }
        filteredItems.value = items.filter {
            $0.category == filterCategory
        }
    }

    func getData(_ completion:  @escaping ([Item],[Category]) -> ()) {
        SyncnhroManager.instance.doSynchro { items, categories in
            completion(items, categories)
        }
    }


    func  reloadAction() {
        filteredItems.value = [ItemViewModel]()
        getData { items, categories in
            self.populate(items,categories)
        }



    }
    func populate(_ rawItems: [Item], _ rawCategories: [Category]) {
        categories.removeAll()
        items.removeAll()
        for category in rawCategories {
            let categoryViewModel = CategoryViewModel(category)
            categories.append(categoryViewModel)
        }
        categories =  Array(Set(categories)).sorted {
            $0.id < $1.id }
        for item in rawItems {
            if  let categoryViewModel = categories.first (where:{ $0.id == item.getCategoryId()}) {
                let  itemViewModel = ItemViewModel(item, categoryViewModel)
                items.append(itemViewModel)
            }
        }
        filteredItems.value = items
    }

    func getCategories() -> [CategoryViewModel]? {
        return categories
    }
}
