//
//  AppCoordinator.swift
//  TestLeBonCoin
//
//  Created by Damien on 12/10/2020.
//

import Foundation
import UIKit
class AppCoordinator: Coordinator {

    var context: UIViewController?
    var navigationController: UINavigationController?
    var listCoordinator: Coordinator?

    required init() {
    }

    func start() {
        let listCoordinator = ListCoordinator(from: navigationController, screen: context)
        self.listCoordinator = listCoordinator
        self.listCoordinator?.start()
    }
}
