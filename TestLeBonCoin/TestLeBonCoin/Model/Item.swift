//
//  Item.swift
//  TestLeBonCoin
//
//  Created by Damien on 23/09/2020.
//

import Foundation

fileprivate enum ItemCodingKeys: String, CodingKey {
    case id
    case categoryId = "category_id"
    case title
    case description
    case price
    case imagesUrl = "images_url"
    case isUrgent = "is_urgent"
    case creationDate = "creation_date"

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

    private var id: Int?
    private var categoryId: Int?
    private var title: String?
    private var description: String?
    private var price: Float?
    private var imagesUrl :[String:String]?
    private var largeImage : String?
    private var smallImage: String?
    private var creation_date: Date?
    private var urgent: Bool?

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ItemCodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.categoryId = try container.decodeIfPresent(Int.self, forKey: .categoryId)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.price = try container.decodeIfPresent(Float.self, forKey: .price)
        self.imagesUrl = try container.decodeIfPresent([String: String].self, forKey: .imagesUrl)
        if let urls = self.imagesUrl {
            self.largeImage = urls["thumb"]
            self.smallImage = urls["small"]
        }
        self.creation_date = try container.decodeIfPresent(Date.self, forKey: .creationDate)
        self.urgent = try container.decodeIfPresent(Bool.self, forKey: .isUrgent)
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
        self.categoryId = catId
        self.description = description
        self.title = title
        self.price = price
        self.smallImage = smallImage
        self.largeImage = largeImage
        self.creation_date = creationDate
        self.urgent = isUrgent
    }

    public func getId() -> Int {
        return id ?? -1
    }

    public func getCategoryId() -> Int {
        return categoryId ?? -1
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
        return urgent ?? false
    }



}
