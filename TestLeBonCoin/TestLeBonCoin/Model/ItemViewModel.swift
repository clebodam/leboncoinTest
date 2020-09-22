//
//  ItemViewModel.swift
//  TestLeBonCoin
//
//  Created by Damien on 22/09/2020.
//

import Foundation

class ItemViewModel {
    var title: String
    var description: String
    var category: CategoryViewModel
    var id :  String

    init(title: String, description: String, id: String, category: CategoryViewModel) {
        self.title = title
        self.id = id
        self.category = category
        self.description = description
    }
}
