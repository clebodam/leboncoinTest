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
    var isSynchronizing = Dynamic(false)
    private var items = [ItemViewModel]()
    var filteredItems: Dynamic<[ItemViewModel]> = Dynamic([ItemViewModel]())

    func filter() {
        var allItems = items
        if let filterCategory = filterCategory  {
            allItems = items.filter {
                $0.category == filterCategory
            }
        }
        var sortedItems = [ItemViewModel] ()
        let urgentItems = allItems.filter {
            $0.isUrgent
        }.sorted {
            $0.creation_date ?? Date() < $1.creation_date ?? Date()
        }
        let nonUrgentItems = allItems.filter {
            !$0.isUrgent
        }.sorted {
            $0.creation_date ?? Date() < $1.creation_date ?? Date()
        }
        sortedItems.append(contentsOf: urgentItems)
        sortedItems.append(contentsOf: nonUrgentItems)
        filteredItems.value = sortedItems
    }

    func getData(_ completion:  @escaping ([Item],[Category]) -> ()) {
        isSynchronizing.value = true
        SyncnhroManager.instance.doSynchro { items, categories in
            completion(items, categories)
            self.isSynchronizing.value = false
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
        filter()
    }

    func getCategories() -> [CategoryViewModel]? {
        return categories
    }

    func getItemViewModel( atIndexPath: IndexPath) -> ItemViewModel? {
        let index  = atIndexPath.row
        let items = filteredItems.value
        if items.count > index {
            return items[index]
        }
        return nil
    }
}
