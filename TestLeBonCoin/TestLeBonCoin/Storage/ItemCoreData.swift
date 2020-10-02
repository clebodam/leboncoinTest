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
    @NSManaged var category_id: Int
    @NSManaged var title: String
    @NSManaged var descr: String
    @NSManaged var price: Float
    @NSManaged var images_url :[String:String]
    @NSManaged var large_image_url : String?
    @NSManaged var small_image_url: String?
    @NSManaged var creation_date: Date?
    @NSManaged var is_urgent: Bool
}
