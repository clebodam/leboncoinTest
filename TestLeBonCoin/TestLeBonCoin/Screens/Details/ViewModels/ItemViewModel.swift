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
    var price: Float
    var creation_date: Date?
    init(_ item:ItemProtocol, _ category: CategoryViewModel) {
        self.title = item.getTitle()
        self.id = item.getId()
        self.category = category
        self.description = item.getDescription()
        self.isUrgent = item.isUrgent()
        self.smallImageUrl = item.getSmallImageUrl()
        self.largeImageUrl = item.getLargeImageUrl()
        self.creation_date = item.getCreationDate()
        self.price = item.getPrice()
    }

    func getCreationDate() -> String? {
        var dateString: String? = nil
        if let date = creation_date {
            dateString = DateFormatter.europeanFormat.string(from: date)
        }
        return dateString
    }
}
