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
    private var id: Int?
    private var category_id: Int?
    private var title: String?
    private var description: String?
    private var price: Float?
    private var images_url :[String:String]?
    private var creation_date: Date?
    private var is_urgent: Bool?

    init() {
        id = Int.random(in :0..<100)
        category_id = Int.random(in :0..<20)
        title = " title of \(id!)"
        description = " description of \(id!)"
        price = Float(Int.random(in : 0...1000))
        creation_date = generateRandomDate(daysBack: 10)
        is_urgent = Bool.random()
        images_url = [String:String]()
    }
    
    func getId() -> Int {
        return id!
    }

    func getCategoryId() -> Int {
        return category_id!
    }

    func getTitle() -> String {
        return title!
    }

    func getDescription() -> String {
        return description!
    }

    func getPrice() -> Float {
        return price!
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
        return  is_urgent!
    }


}
