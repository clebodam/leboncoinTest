//
//  UIWindow+init.swift
//  TestLeBonCoin
//
//  Created by Damien on 22/09/2020.
//

import Foundation
import UIKit

public extension UIWindow {

    func setup(_ rootVC: UIViewController?) {
        self.rootViewController = rootVC
        self.makeKeyAndVisible()
    }
}
