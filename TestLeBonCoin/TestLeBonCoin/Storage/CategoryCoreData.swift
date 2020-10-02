//
//  CategoryCoreData.swift
//  TestLeBonCoin
//
//  Created by Damien on 02/10/2020.
//

import Foundation
import CoreData

class CategoryCoreData: NSManagedObject {
    @NSManaged var id: Int
    @NSManaged var name: String

}
