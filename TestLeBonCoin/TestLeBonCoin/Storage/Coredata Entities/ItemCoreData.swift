//
//  ItemCoreData.swift
//  TestLeBonCoin
//
//  Created by Damien on 02/10/2020.
//

import Foundation
import CoreData

class ItemCoreData: NSManagedObject {
    @NSManaged var id: Int
    @NSManaged var categoryId: Int
    @NSManaged var title: String
    @NSManaged var descr: String
    @NSManaged var price: Float
    @NSManaged var largeImage : String?
    @NSManaged var smallImage: String?
    @NSManaged var creationDate: Date?
    @NSManaged var urgent: Bool
}
