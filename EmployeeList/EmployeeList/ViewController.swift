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
    var network = Network()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Employees"
        
        self.tableView.register(UINib(nibName: "EmployeeCell", bundle: nil), forCellReuseIdentifier: "EmployeeCell")
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshTapped))
    
        
        // TODO show loading spinner
        
        // Fetch the employee data and refresh the table
        Task {
            tableData = await network.loadData()
            tableView.reloadData()
        }
    }
    
    @objc func refreshTapped() {
        
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
        } else {
            cell.nameLabel.text = "Chad Weigle"
            cell.teamLabel.text = "Appointments"
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
