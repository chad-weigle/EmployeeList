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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Employees"
        
        self.tableView.register(UINib(nibName: "EmployeeCell", bundle: nil), forCellReuseIdentifier: "EmployeeCell")
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshTapped))
    
        
        // TODO setup and show loading spinner
        
        
        loadTableData()
    }
    
    @objc func refreshTapped() {
        print("INFO: Refresh button tapped.")
        loadTableData()
    }
    
    // Fetch the employee data and refresh the table
    func loadTableData() {
        Task {
            tableData = await network.fetchData()
            tableView.reloadData()
        }
    }
    
    func loadCellImage(employee: Employee) -> UIImage? {
        // TODO load from cache
        if let smallImage = smallImages[employee.uuid] {
            return smallImage
        }
        
        // Nothing cached so load it via API
        Task {
            if let urlString = employee.photo_url_small,
               let smallImage = await network.fetchSmallImage(imageURLString: urlString) {
                smallImages[employee.uuid] = smallImage
                
                await MainActor.run {
                    tableView.reloadData()
                }
            }
        }
        
        return nil
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
        
        if let data = tableData {
            let employee = data[indexPath.row]
            cell.nameLabel.text = employee.full_name
            cell.teamLabel.text = employee.team
            cell.smallImageView.image = UIImage(systemName: "photo")
            cell.smallImageView.image = loadCellImage(employee: employee)
        } else {
            cell.nameLabel.text = "Test name"
            cell.teamLabel.text = "Test team"
            cell.smallImageView.image = UIImage(systemName: "photo")
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
