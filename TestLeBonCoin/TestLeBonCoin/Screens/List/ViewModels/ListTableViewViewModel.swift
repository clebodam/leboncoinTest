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
    var filteredItems: Dynamic<[ItemViewModel]> = Dynamic([ItemViewModel]())
    
    private var items = [ItemViewModel]()
    private var categories: [CategoryViewModel] =  [CategoryViewModel]()
    private var synchroManager: SynchroProtocol?


    func register(synchroManager: SynchroProtocol, dao: DaoProtocol, networkManager: NetWorkManagerProtocol) {
        self.synchroManager = synchroManager
        self.synchroManager?.register(netWorkManager:networkManager, dao: dao)
    }

    
    
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
            $0.creation_date ?? Date() > $1.creation_date ?? Date()
        }
        let nonUrgentItems = allItems.filter {
            !$0.isUrgent
        }.sorted {
            $0.creation_date ?? Date() > $1.creation_date ?? Date()
        }
        sortedItems.append(contentsOf: urgentItems)
        sortedItems.append(contentsOf: nonUrgentItems)
        filteredItems.value = sortedItems
    }

    func getData(_ completion:  @escaping ([ItemProtocol],[CategoryProtocol]) -> ()) {
        self.isSynchronizing.value = true
        synchroManager?.doSynchro { items, categories in
            completion(items, categories)
            self.isSynchronizing.value = false
        }
    }

    func  reloadAction() {
        filteredItems.value = [ItemViewModel]()
        getData { items, categories in
           _ = self.populateAndFilter(items,categories)
        }
    }

     func populateAndFilter(_ rawItems: [ItemProtocol], _ rawCategories: [CategoryProtocol])  -> [ItemViewModel]{
        _ = populate(rawItems,rawCategories)
        filter()
        return filteredItems.value
    }

    func populate(_ rawItems: [ItemProtocol], _ rawCategories: [CategoryProtocol]) -> [ItemViewModel] {
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

    func presentFilter(on viewController: UIViewController, sender: UIView) {
        let alert = UIAlertController(title: NSLocalizedString("filter_title", comment: ""),
                                      message: nil,
                                      preferredStyle: UIAlertController.Style.actionSheet)
        alert.isModalInPopover = true
        var pickerViewValues: [[String]] = [[String]]()
        if let values = self.getCategories()?.map({$0.name }) {
            pickerViewValues = [values]
        }
        var selectedIndex = 0
        if let selectedCategory =  self.filterCategory {
            selectedIndex =  self.getCategories()?.firstIndex(of:  selectedCategory) ?? 0
        }

        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: selectedIndex)

        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            let categories =  self.getCategories()
            self.filterCategory = categories?[index.row]
        }

        let okAction = UIAlertAction(title: NSLocalizedString("ok_button", comment: ""), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if  self.filterCategory == nil {
                let categories =  self.getCategories()
                if let cat = categories?[0] {
                    self.filterCategory = cat
                }
            }
            self.filter()
        })

        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel_button", comment: ""), style: .destructive, handler: { _ in
            self.filterCategory = nil
            self.filter()
        })
        alert.addAction(cancelAction)

        if let presenter = alert.popoverPresentationController {
            presenter.barButtonItem =  UIBarButtonItem(customView: sender)
        }
        // here we have an issue Will attempt to recover by breaking constraint
        //<NSLayoutConstraint:0x600001823390 UIView:0x7fb277d68230.width == - 16   (active)>
        // this a known bug  https://stackoverflow.com/questions/55372093/uialertcontrollers-actionsheet-gives-constraint-error-on-ios-12-2-12-3

        viewController.parent?.present(alert, animated: true)
    }
}
