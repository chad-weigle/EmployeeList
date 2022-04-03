//
//  Network.swift
//  EmployeeList
//
//  Created by Chad Weigle on 4/1/22.
//

import Foundation
import UIKit

class Network {
    func fetchData() async -> [Employee]? {
        let url = "https://s3.amazonaws.com/sq-mobile-interview/employees.json"            // Good
//        let url = "https://s3.amazonaws.com/sq-mobile-interview/employees_malformed.json"  // Bad
//        let url = "https://s3.amazonaws.com/sq-mobile-interview/employees_empty.json"      // Empty
        guard let url = URL(string: url) else {
            print("ERROR: Failed to create URL.")
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decodedResponse = try JSONDecoder().decode(Response.self, from: data)
            let results = decodedResponse.employees
            sleep(4)  // Uncomment for testing loading state
            return results
        } catch {
            print("ERROR: Invalid data. \(error)")
            return nil
        }
    }
    
    func fetchSmallImage(imageURLString: String) async -> UIImage? {
        guard let url = URL(string: imageURLString) else {
            print("ERROR: Failed to create URL.")
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let image = UIImage(data: data)
            return image
        } catch {
            print("ERROR: Invalid data. \(error)")
            return nil
        }
    }
}

struct Response: Codable {
    var employees: [Employee]
}

struct Employee: Codable {
    var uuid: String  // The unique identifier for the employee. Represented as a UUID.
    var full_name: String  // The full name of the employee.
    var phone_number: String?  // The phone number of the employee, sent as an unformatted string (eg, 5556661234).
    var email_address: String  //The email address of the employee.
    var biography: String?  // A short, tweet-length (~300 chars) string that the employee provided to describe themselves.
    var photo_url_small: String?  // The URL of the employee’s small photo. Useful for list view.
    var photo_url_large: String?  // The URL of the employee’s full-size photo.
    var team: String  // The team they are on, represented as a human readable string.
    var employee_type: EmployeeType  // How the employee is classified.
}

enum EmployeeType: String, Codable {
    case FULL_TIME
    case PART_TIME
    case CONTRACTOR
}
