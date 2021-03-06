//
//  Category.swift
//  TestLeBonCoin
//
//  Created by Damien on 23/09/2020.
//

import Foundation

fileprivate enum CodingKeys: String, CodingKey {
    case id
    case name
}

public protocol CategoryProtocol: Codable {
     func getName() -> String
     func getId() -> Int
     init(id: Int, name: String)
}

class Category: CategoryProtocol {
    private var id: Int?
    private var name: String?

    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)

    }

    required init(id: Int, name: String) {
        self.id = id
        self.name = name
    }

    public func getName() -> String {
        return name ?? ""
    }

    public func getId() -> Int {
        return id ?? -1
    }
}

