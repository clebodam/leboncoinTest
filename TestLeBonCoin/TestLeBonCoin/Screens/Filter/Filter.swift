//
//  Filter.swift
//  TestLeBonCoin
//
//  Created by Damien on 30/09/2020.
//

import Foundation
import UIKit

protocol Filterprotocol {
    func createFilter(on screen :  UIViewController, from: UIView) -> UIViewController
}

class Filter<I:ItemProtocol, C:CategoryProtocol>: Filterprotocol {

    private let viewModel: ListTableViewViewModel<I,C>
    init(viewModel:ListTableViewViewModel<I,C>){
        self.viewModel = viewModel
    }
    
    func createFilter(on screen :  UIViewController, from: UIView) -> UIViewController {
        let alert = UIAlertController(title: NSLocalizedString("filter_title", comment: ""),
                                      message: nil,
                                      preferredStyle: UIAlertController.Style.actionSheet)
        alert.isModalInPopover = true
        var pickerViewValues: [[String]] = [[String]]()
        if let values = self.viewModel.getCategories()?.map({$0.name }) {
            pickerViewValues = [values]
        }
        var selectedIndex = 0
        if let selectedCategory =  self.viewModel.filterCategory {
            selectedIndex =  self.viewModel.getCategories()?.firstIndex(of:  selectedCategory) ?? 0
        }

        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: selectedIndex)

        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            let categories =  self.viewModel.getCategories()
            self.viewModel.filterCategory = categories?[index.row]
        }

        let okAction = UIAlertAction(title: NSLocalizedString("ok_button", comment: ""), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if  self.viewModel.filterCategory == nil {
                let categories =  self.viewModel .getCategories()
                if let cat = categories?[0] {
                    self.viewModel.filterCategory = cat
                }
            }
            self.viewModel.reloadAction()
        })

        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel_button", comment: ""), style: .destructive, handler: { _ in
            self.viewModel.filterCategory = nil
            self.viewModel.reloadAction()
        })
        alert.addAction(cancelAction)

        if let presenter = alert.popoverPresentationController {
            presenter.barButtonItem =  UIBarButtonItem(customView: from)
        }
        // here we have an issue Will attempt to recover by breaking constraint
        //<NSLayoutConstraint:0x600001823390 UIView:0x7fb277d68230.width == - 16   (active)>
        // this a known bug  https://stackoverflow.com/questions/55372093/uialertcontrollers-actionsheet-gives-constraint-error-on-ios-12-2-12-3
       return alert
    }
}
