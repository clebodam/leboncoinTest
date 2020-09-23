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
    var id :  Int
    var smallImageUrl :  String?
    var largeImageUrl :  String?
    var isUrgent: Bool

    init(_ item:Item, _ category: CategoryViewModel) {
        self.title = item.getTitle()
        self.id = item.getId()
        self.category = category
        self.description = item.getDescription()
        self.isUrgent = item.isUrgent()
        self.smallImageUrl = item.getSmallImageUrl()
        self.largeImageUrl = item.getLargeImageUrl()
    }
}
