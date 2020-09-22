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

        let message = "\n\n\n\n\n\n"
        let alert = UIAlertController(title: "Please choose your categoy to filter", message: message, preferredStyle: UIAlertController.Style.actionSheet)
        alert.isModalInPopover = true

        let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: UIScreen.main.bounds.size.width - 20, height: 140)) // CGRectMake(left, top, width, height) - left and top are like margins
        pickerFrame.tag = 555
        //set the pickers datasource and delegate
        pickerFrame.delegate = self
        pickerFrame.dataSource = self
        //Add the picker to the alert controller
        alert.view.addSubview(pickerFrame)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            if  self.viewModel.filterCategory == nil {
                let categories =  self.viewModel.getCategories()
                self.viewModel.filterCategory = categories?[pickerFrame.selectedRow(inComponent: 0)]
            }
            self.viewModel.filter()
          //Perform Action
        })

        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: { _ in
            self.viewModel.filterCategory = nil
            self.viewModel.filter()
        })
        alert.addAction(cancelAction)
        self.parent!.present(alert, animated: true, completion: {  })
    }
}

extension ListTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - UIPickerViewDelegation
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.getCategories()?.count ?? 0
    }


    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let categories =  viewModel.getCategories()
        return categories?[row].name

    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let categories =  viewModel.getCategories()
        viewModel.filterCategory = categories?[row]
    }

}
