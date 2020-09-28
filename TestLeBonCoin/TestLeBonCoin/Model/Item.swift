//
//  Item.swift
//  TestLeBonCoin
//
//  Created by Damien on 23/09/2020.
//

import Foundation

fileprivate enum CodingKeys: String, CodingKey {
    case id
    case category_id
    case title
    case description
    case price
    case images_url
    case creation_date
    case is_urgent
}
public protocol ItemProtocol: Codable {
    func getId() -> Int
    func getCategoryId() -> Int
    func getTitle() -> String
    func getDescription() -> String
    func getPrice() -> Float
    func getLargeImageUrl() -> String?
    func getSmallImageUrl() -> String?
    func getCreationDate() -> Date?
    func isUrgent() -> Bool
    init(id: Int,
         title: String,
         description: String,
         catId: Int,
         price: Float,
         largeImage: String,
         smallImage: String,
         creationDate: Date,
         isUrgent: Bool )
}


class Item: ItemProtocol {
    static func type() -> ItemProtocol.Type {
        return Item.self
    }

    private var id: Int?
    private var category_id: Int?
    private var title: String?
    private var description: String?
    private var price: Float?
    private var images_url :[String:String]?
    private var largeImage : String?
    private var smallImage: String?
    private var creation_date: Date?
    private var is_urgent: Bool?

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.category_id = try container.decodeIfPresent(Int.self, forKey: .category_id)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.price = try container.decodeIfPresent(Float.self, forKey: .price)
        self.images_url = try container.decodeIfPresent([String: String].self, forKey: .images_url)
        if let urls = self.images_url {
            self.largeImage = urls["thumb"]
            self.smallImage = urls["small"]
        }
        self.creation_date = try container.decodeIfPresent(Date.self, forKey: .creation_date)
        self.is_urgent = try container.decodeIfPresent(Bool.self, forKey: .is_urgent)
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

    public func getId() -> Int {
        return id ?? -1
    }

    public func getCategoryId() -> Int {
        return category_id ?? -1
    }

    public func getTitle() -> String {
        return title ?? ""
    }

    public func getDescription() -> String {
        return description ?? ""
    }

    public func getPrice() -> Float {
        return price ?? 0.0
    }

    public func getLargeImageUrl() -> String? {
        return largeImage ?? ""
    }

    public func getSmallImageUrl() -> String? {
        return smallImage ?? ""
    }

    public func getCreationDate() -> Date? {
        return creation_date ?? Date()
    }

    public func isUrgent() -> Bool {
        return is_urgent ?? false
    }



}
