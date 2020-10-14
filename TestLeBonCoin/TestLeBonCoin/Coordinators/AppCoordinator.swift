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

    required init() {
    }

    func start() {
        let listCoordinator = ListCoordinator(from: navigationController, screen: context)
        if let context = context as? ListCoordinatorScreen {
            context.registerCoordinator(coordinator: listCoordinator)
        }
        listCoordinator.start()
    }

    func configureAndStartFromWindow( _ window: UIWindow) {
        window.setup(navigationController)
        start()
    }
}
