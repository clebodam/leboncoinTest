//
//  TestItem.swift
//  TestLeBonCoinTests
//
//  Created by Damien on 25/09/2020.
//

import Foundation
func generateRandomDate(daysBack: Int)-> Date?{
        let day = arc4random_uniform(UInt32(daysBack))+1
        let hour = arc4random_uniform(23)
        let minute = arc4random_uniform(59)

        let today = Date(timeIntervalSinceNow: 0)
        let gregorian  = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        var offsetComponents = DateComponents()
        offsetComponents.day = -1 * Int(day - 1)
        offsetComponents.hour = -1 * Int(hour)
        offsetComponents.minute = -1 * Int(minute)

        let randomDate = gregorian?.date(byAdding: offsetComponents, to: today, options: .init(rawValue: 0) )
        return randomDate
    }

class TestItem: ItemProtocol {
    private var id: Int
    private var category_id: Int
    private var title: String
    private var description: String
    private var price: Float
    private var images_url :[String:String]?
    private var largeImage : String?
    private var smallImage: String?
    private var creation_date: Date
    private var is_urgent: Bool

    init() {
        id = Int.random(in :0..<100)
        category_id = Int.random(in :0..<20)
        title = " title of \(id)"
        description = " description of \(id)"
        price = Float(Int.random(in : 0...1000))
        creation_date = generateRandomDate(daysBack: 10) ?? Date()
        is_urgent = Bool.random()
        images_url = [String:String]()
    }

    required init(id: Int,
         title: String,
         description: String,
         catId: Int,
         price: Float,
         largeImage: String,
         smallImage: String,
         creationDate: Date,
         isUrgent: Bool ) {

        self.id = id
        self.category_id = catId
        self.description = description
        self.title = title
        self.price = price
        self.smallImage = smallImage
        self.largeImage = largeImage
        self.creation_date = creationDate
        self.is_urgent = isUrgent
    }
    
    func getId() -> Int {
        return id
    }

    func getCategoryId() -> Int {
        return category_id
    }

    func setCategoryId(id :Int)  {
        category_id = id
    }

    func getTitle() -> String {
        return title
    }

    func getDescription() -> String {
        return description
    }

    func getPrice() -> Float {
        return price
    }

    func getLargeImageUrl() -> String? {
        return  nil
    }

    func getSmallImageUrl() -> String? {
        return nil
    }

    func getCreationDate() -> Date? {
        return creation_date
    }

    func isUrgent() -> Bool {
        return  is_urgent
    }

    static func createItem(urgent:Bool, catId: Int) -> TestItem {
        let item = TestItem()
        item.is_urgent = urgent
        item.category_id = catId
        return item
    }

    static func createItems(urgent:Bool, count:Int,categoriesCount:Int) -> [TestItem] {
        var items = [TestItem]()
        for  i in 0...count {
            items.append(createItem(urgent: urgent, catId: i%categoriesCount))
        }
        return items
    }
}
