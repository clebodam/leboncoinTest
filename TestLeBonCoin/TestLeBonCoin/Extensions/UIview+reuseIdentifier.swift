//
//  UIview+reuseIdentifier.swift
//  TestLeBonCoin
//
//  Created by Damien on 30/09/2020.
//

import Foundation

protocol ReuseIdentifierProtocol {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifierProtocol {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
        }
}
