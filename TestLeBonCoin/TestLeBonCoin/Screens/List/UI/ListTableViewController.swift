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
        bindViewModel()
        reloadAction()
        setNeedsStatusBarAppearanceUpdate()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = .white

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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
        let alert = UIAlertController(title: "Please choose your categoy to filter",
                                      message: nil,
                                      preferredStyle: UIAlertController.Style.actionSheet)
        alert.isModalInPopover = true
        var pickerViewValues: [[String]] = [[String]]()
        if let values = viewModel.getCategories()?.map({$0.name }) {
            pickerViewValues = [values]
        }
        var selectedIndex = 0
        if let selectedCategory =  self.viewModel.filterCategory {
            selectedIndex =  self.viewModel.getCategories()?.firstIndex(of:  selectedCategory) ?? 0
        }

        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: selectedIndex)

        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            let categories =  self.viewModel.getCategories()
            self.viewModel.filterCategory = categories?[index.row]
        }

        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if  self.viewModel.filterCategory == nil {
                let categories =  self.viewModel.getCategories()
                self.viewModel.filterCategory = categories?[0]
            }
            self.viewModel.filter()
        })

        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "No Filter", style: .destructive, handler: { _ in
            self.viewModel.filterCategory = nil
            self.viewModel.filter()
        })
        alert.addAction(cancelAction)

        if let presenter = alert.popoverPresentationController {
            presenter.barButtonItem =  UIBarButtonItem(customView: sender)
        }
        // here we have an issue Will attempt to recover by breaking constraint
        //<NSLayoutConstraint:0x600001823390 UIView:0x7fb277d68230.width == - 16   (active)>
        // this a known bug  https://stackoverflow.com/questions/55372093/uialertcontrollers-actionsheet-gives-constraint-error-on-ios-12-2-12-3

        self.parent?.present(alert, animated: true)
    }
}

