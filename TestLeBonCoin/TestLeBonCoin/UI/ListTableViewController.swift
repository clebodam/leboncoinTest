//
//  ListTableViewController.swift
//  TestLeBonCoin
//
//  Created by Damien on 22/09/2020.
//

import UIKit

class ListTableViewController: UITableViewController {
    var filterButton: UIBarButtonItem?
    var viewModel = ListTableViewViewModel()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.filterButton = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterAction))
        self.navigationItem.rightBarButtonItem = self.filterButton
        self.tableView.register(UITableViewCell.self,forCellReuseIdentifier: "reuseIdentifier")
        bindViewModel()
    }

    func bindViewModel() {
        viewModel.filteredItems.bind({ [weak self] (items) in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        })
    }

    // MARK: - Table view delegation

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

        cell.textLabel?.text = viewModel.filteredItems.value[indexPath.row].title
        // Configure the cell...

        return cell
    }


    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */

    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */

    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

     }
     */

    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

    // MARK: - Actions
    @objc func filterAction() {

        let alert = UIAlertController(title: "Please choose your categoy to filter", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
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


        self.parent!.present(alert, animated: true, completion: {  })
    }
}

