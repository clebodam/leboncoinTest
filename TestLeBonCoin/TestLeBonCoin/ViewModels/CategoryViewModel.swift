//
//  Category.swift
//  TestLeBonCoin
//
//  Created by Damien on 22/09/2020.
//

import Foundation

class CategoryViewModel :Hashable {
    static func == (lhs: CategoryViewModel, rhs: CategoryViewModel) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    var id :  Int
    var name : String

    init(_ category: Category) {
        self.name = category.getName()
        self.id = category.getId()
    }



}
