//
//  ListTableViewController.swift
//  TestLeBonCoin
//
//  Created by Damien on 22/09/2020.
//

import UIKit

class ListTableViewController: UITableViewController {
    // MARK: - PROPERTIES
    var filterButton: UIBarButtonItem?
    var reloadButton: UIBarButtonItem?
    var viewModel = ListTableViewViewModel<Item,Category>()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    // MARK: - UI SETUP
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        reloadAction()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = .white
    }

    func setupUI() {
        self.view.backgroundColor = .white
        // set accessibilityIdentifier for testUI
        tableView.accessibilityIdentifier = "tableView"
        // register Synchronization to ViewModel
        viewModel.register(synchroManager: SynchroManager<Item,Category>(),
                           dao: Dao<Item,Category>(),
                           networkManager: NetWorkManager<Item,Category>())
        // bar items setup
        let button = UIButton()
        button.addTarget(self, action: #selector(filterAction(sender:)), for: .touchUpInside)

        button.setImage(UIImage(named: "filter"), for: UIControl.State())
        self.filterButton = UIBarButtonItem(customView: button)
        self.filterButton?.accessibilityIdentifier = "filter"
        let button1 = UIButton()
        button1.addTarget(self, action: #selector(reloadAction), for: .touchUpInside)
        button1.setImage(UIImage(named: "refresh"), for: UIControl.State())
        self.reloadButton = UIBarButtonItem(customView: button1)
        self.reloadButton?.accessibilityIdentifier = "reload"
        self.navigationItem.leftBarButtonItem = self.reloadButton
        self.navigationItem.rightBarButtonItem = self.filterButton
        // table View setup
        self.tableView.register(ItemTableViewCell.self,forCellReuseIdentifier: "reuseIdentifier")
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 150
        self.tableView.separatorStyle = .none
    }

    func bindViewModel() {
        viewModel.filteredItems.bind({ [weak self] (items) in
            DispatchQueue.main.async {
                self?.tableView.setContentOffset(.zero, animated: false)
                self?.tableView.reloadData()
            }
        })
        viewModel.isSynchronizing.bind { [weak self]  (value) in
            DispatchQueue.main.async {
                if value {
                    self?.reloadButton?.customView?.infiniteRotate()
                } else {
                    self?.reloadButton?.customView?.removeAllAnimations()
                }
            }
        }
    }

    // MARK: - TableView delegation

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredItems.value.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        if let itemCell = cell as? ItemTableViewCell {
            if let itemViewModel = viewModel.getItemViewModel(atIndexPath: indexPath) {
                itemCell.viewModel = itemViewModel
            }
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let itemViewModel = viewModel.getItemViewModel(atIndexPath: indexPath) {
            self.navigationController?.pushViewController(DetailsViewController(itemViewModel), animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let animation = AnimationFactory.slideIn(duration: 0.2, delayFactor: 0)
        let animator = Animator(animation: animation)
        animator.animate(cell: cell, at: indexPath, in: tableView)
        cell.accessibilityIdentifier = "\(indexPath.row)"
    }

    // MARK: - Actions

    @objc func reloadAction() {
        self.viewModel.reloadAction()
    }
    
    @objc func filterAction(sender: UIButton) {
        Filter(viewModel: viewModel).showFilter(on: self, from: sender )
    }
}

