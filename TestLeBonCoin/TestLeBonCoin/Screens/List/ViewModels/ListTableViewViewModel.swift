//
//  ListTableViewViewModel.swift
//  TestLeBonCoin
//
//  Created by Damien on 22/09/2020.
//

import Foundation
import UIKit
class ListTableViewViewModel<I:ItemProtocol,C:CategoryProtocol> {
    var filterCategory: CategoryViewModel?
    var isSynchronizing = Dynamic(false)
    var synChronizingError: Dynamic<NetworkError?> = Dynamic(nil)
    var filteredItems: Dynamic<[ItemViewModel]> = Dynamic([ItemViewModel]())
    private var categories: [CategoryViewModel] =  [CategoryViewModel]()
    private var synchroManager: SynchroProtocol?


    func register(synchroManager: SynchroProtocol, dao: DaoProtocol, networkManager: NetWorkManagerProtocol) {
        self.synchroManager = synchroManager
        self.synchroManager?.register(netWorkManager:networkManager, dao: dao)
    }

    func getData( filteredByCategoryId : Int?, completion:  @escaping CompletionBlock) {
        self.isSynchronizing.value = true
        synchroManager?.doSynchro(filteredByCategoryID: filteredByCategoryId) { items, categories, error in
            if let error = error {
                self.synChronizingError.value = error
            }
            completion(items, categories, error)
            self.isSynchronizing.value = false
        }
    }

    func  reloadAction() {
        filteredItems.value = [ItemViewModel]()
        getData(filteredByCategoryId: filterCategory?.id) { items, categories, error in
            self.synChronizingError.value = error
                _ = self.populateAndFilter(items,categories)
        }
    }

     func populateAndFilter(_ rawItems: [ItemProtocol], _ rawCategories: [CategoryProtocol])  -> [ItemViewModel]{
        let result = populate(rawItems,rawCategories)
        filteredItems.value = result
        return result
    }

    func populate(_ rawItems: [ItemProtocol], _ rawCategories: [CategoryProtocol]) -> [ItemViewModel] {
        categories.removeAll()
        var items = [ItemViewModel]()
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
        return items
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
