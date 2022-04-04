//
//  ViewController.swift
//  EmployeeList
//
//  Created by Chad Weigle on 4/1/22.
//

import UIKit

class EmployeeTableViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    var tableData: [Employee]?
    var smallImages: [String:UIImage] = [:]
    var network = Network()
    var employeeImageService = EmployeeImageService()
    var loadingStateView = TableLoadingState.instanceFromNib()
    var emptyStateView = TableEmptyState.instanceFromNib()
    var errorStateView = TableErrorState.instanceFromNib()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Employees"
        
        self.tableView.register(UINib(nibName: "EmployeeCell", bundle: nil), forCellReuseIdentifier: "EmployeeCell")
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshTapped))
        
        // Setup empty state
        tableView.backgroundView = loadingStateView
        
        loadTableData()
    }
    
    @objc func refreshTapped() {
        print("INFO: Refresh button tapped.")
        tableData = nil
        tableView.reloadData()
        loadTableData()
    }
    
    // Fetch the employee data and refresh the table
    func loadTableData() {
        showLoading()
        Task {
            tableData = await network.fetchData()
            
            // Show an error state or empty state view
            if tableData == nil {
                tableView.backgroundView = errorStateView
                return
            } else if tableData?.count == 0 {
                tableView.backgroundView = emptyStateView
                return
            }
            
            await MainActor.run {
                hideLoading()
            }
            
            tableView.reloadData()
        }
    }
    
    // Load the cell image from the cache
    func loadCellImage(employee: Employee) -> UIImage? {
        if let url = employee.photo_url_small {
            // See if we have the image in memory first
            if let smallImage = smallImages[url] {
                return smallImage
            } else {
                Task {
                    let image = await employeeImageService.getImage(url: url)
                    smallImages[url] = image
                    await MainActor.run {
                        /*
                         This is pretty inefficient since this reloads the entire table after fetching a single image.
                         A better implementation would be to load the image into the specific cell IF that cell is
                         still showing the correct employee that matches this image.
                         */
                        tableView.reloadData()
                    }
                }
            }
        }
        
        return nil
    }
    
    func showLoading() {
        tableView.backgroundView = loadingStateView
    }
    
    func hideLoading() {
        tableView.backgroundView = nil
    }
}

extension EmployeeTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped row")
    }
}

extension EmployeeTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeCell", for: indexPath) as! EmployeeCell
        
        cell.smallImageView.image = UIImage(systemName: "photo")
        if let data = tableData {
            let employee = data[indexPath.row]
            cell.nameLabel.text = employee.full_name
            cell.teamLabel.text = employee.team
            if let image = loadCellImage(employee: employee) {
                cell.smallImageView.image = image
            } else {
                cell.smallImageView.image = UIImage(systemName: "photo")
            }
        } else {
            cell.nameLabel.text = "Test name"
            cell.teamLabel.text = "Test team"
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
}
