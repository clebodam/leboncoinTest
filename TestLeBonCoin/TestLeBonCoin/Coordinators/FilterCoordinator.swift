//
//  FilterCoordinator.swift
//  TestLeBonCoin
//
//  Created by Damien on 12/10/2020.
//

import Foundation
import UIKit
class FilterCoordinator: Coordinator {
    
    var context: UIViewController?
    var navigationController: UINavigationController?
    required init() {
    }

    func start() {
        self.present(self.context)
    }

}
