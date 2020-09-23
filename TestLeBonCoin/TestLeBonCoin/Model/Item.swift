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
class Item: Codable {
    private var id: Int?
    private var category_id: Int?
    private var title: String?
    private var description: String?
    private var price: Float?
    private var images_url :[String:String]?
    private var creation_date: Date?
    private var is_urgent: Bool?

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.category_id = try container.decodeIfPresent(Int.self, forKey: .category_id)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.price = try container.decodeIfPresent(Float.self, forKey: .price)
        self.images_url = try container.decode([String: String].self, forKey: .images_url)
        self.creation_date = try container.decode(Date.self, forKey: .creation_date)
        self.is_urgent = try container.decode(Bool.self, forKey: .is_urgent)
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
        guard let urls = images_url else {
            return nil
        }
        return urls["thumb"]
    }

    public func getSmallImageUrl() -> String? {
        guard let urls = images_url else {
            return nil
        }
        return urls["small"]
    }

    public func getCreationDate() -> Date? {
        return creation_date
    }

    public func isUrgent() -> Bool {
        return is_urgent ?? false
    }
}
