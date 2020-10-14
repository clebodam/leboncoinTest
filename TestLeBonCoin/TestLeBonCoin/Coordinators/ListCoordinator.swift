//
//  ListCoordinator.swift
//  TestLeBonCoin
//
//  Created by Damien on 12/10/2020.
//

import Foundation
import UIKit

protocol ListCoordinatorProtocol {
    func  goToDetail(withModel: ItemViewModel)
    func presentFilter(_ filter: UIViewController)
    func showSynchronizingError(_ error: Error)
}
class ListCoordinator: Coordinator, ListCoordinatorProtocol {

    var context: UIViewController?
    var navigationController: UINavigationController?
    
    required init() {
    }

    func start() {
        self.push(self.context)
    }

    func goToDetail(withModel: ItemViewModel) {
        let detailCoordinator = DetailCoordinator(from: context, screen: DetailsViewController(withModel))
        detailCoordinator.start()
    }

    func presentFilter(_ filter: UIViewController) {
        let filterCoordinator = FilterCoordinator(from: context, screen: filter)
        filterCoordinator.start()
    }

    func showSynchronizingError(_ error: Error) {
        let alert = UIAlertController(title: "Synchronization error", message: error.localizedDescription, preferredStyle:.alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("ok_button", comment: ""), style: .destructive, handler: nil)
        alert.addAction(cancelAction)
        present(alert)
    }
}
