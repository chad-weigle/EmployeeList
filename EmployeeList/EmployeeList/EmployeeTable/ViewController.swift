//
//  ViewController.swift
//  EmployeeList
//
//  Created by Chad Weigle on 4/1/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    var tableData: [Employee]?
    var smallImages: [String:UIImage] = [:]
    var network = Network()
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
            } else if tableData?.count == 0 {
                tableView.backgroundView = emptyStateView
            }
            
            await MainActor.run {
                hideLoading()
            }
            
            tableView.reloadData()
        }
    }
    
    // Load the cell image from the cache or go fetch it from the api (api does table reload)
    func loadCellImage(employee: Employee) -> UIImage? {
        // See if we have the image cached first
        if let smallImage = smallImages[employee.photo_url_small ?? ""] {
            return smallImage
        }
        
        // Nothing cached so load it via API
        Task {
            if let urlString = employee.photo_url_small,
               let smallImage = await network.fetchSmallImage(imageURLString: urlString) {
                smallImages[urlString] = smallImage
                
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
        
        return nil
    }
    
    func showLoading() {
        tableView.backgroundView = loadingStateView
    }
    
    func hideLoading() {
        tableView.backgroundView = nil
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped row")
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeCell", for: indexPath) as! EmployeeCell
        
        cell.smallImageView.image = UIImage(systemName: "photo")
        if let data = tableData {
            let employee = data[indexPath.row]
            cell.nameLabel.text = employee.full_name
            cell.teamLabel.text = employee.team
            cell.smallImageView.image = loadCellImage(employee: employee)
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
}
