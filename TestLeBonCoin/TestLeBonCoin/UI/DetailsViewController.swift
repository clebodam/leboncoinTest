//
//  DetailsViewController.swift
//  TestLeBonCoin
//
//  Created by Damien on 24/09/2020.
//

import UIKit

class DetailsViewController: UIViewController {
    private var viewModel: ItemViewModel

    init(_ viewModel: ItemViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func loadView() {
            view = UIView()
        view.backgroundColor = .red
        }
    

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

}
