//
//  DetailCoordinator.swift
//  TestLeBonCoin
//
//  Created by Damien on 12/10/2020.
//

import Foundation
import UIKit
class DetailCoordinator: Coordinator {

    var context: UIViewController?
    var navigationController: UINavigationController?
    required init() {
    }

    func start() {
        self.push(self.context)
    }

}
