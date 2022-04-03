//
//  NetworkTests.swift
//  EmployeeListTests
//
//  Created by Chad Weigle on 4/2/22.
//

import XCTest
@testable import EmployeeList

class NetworkTests: XCTestCase {
    var network: Network!
    let url = URL(string: "https://s3.amazonaws.com/sq-mobile-interview/employees.json")!
    
    override func setUpWithError() throws {
        let config = URLSessionConfiguration.default
        config.protocolClasses = [MockURLProtocol.self]
        let mockURL = URLSession.init(configuration: config)
        network = Network(urlSession: mockURL)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGoodJSONDecode() async throws {
        // Prepare mock response.
        let jsonString = """
                            {
                                "employees" : [
                                    {
                                        "uuid" : "0d8fcc12-4d0c-425c-8355-390b312b909c",

                                        "full_name" : "Justine Mason",
                                        "phone_number" : "5553280123",
                                        "email_address" : "jmason.demo@squareup.com",
                                        "biography" : "Engineer on the Point of Sale team.",

                                        "photo_url_small" : "https://s3.amazonaws.com/sq-mobile-interview/photos/16c00560-6dd3-4af4-97a6-d4754e7f2394/small.jpg",
                                        "photo_url_large" : "https://s3.amazonaws.com/sq-mobile-interview/photos/16c00560-6dd3-4af4-97a6-d4754e7f2394/large.jpg",

                                        "team" : "Point of Sale",
                                        "employee_type" : "FULL_TIME"
                                    }
                                ]
                            }
                         """
        let data = jsonString.data(using: .utf8)
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        
        // Call API.
        let employees = await network.fetchData()
        guard let employee = employees?[0] as? Employee else {
            XCTFail()
            return
        }
        XCTAssertEqual(employee.uuid, "0d8fcc12-4d0c-425c-8355-390b312b909c", "Incorrect uuid")
        XCTAssertEqual(employee.full_name, "Justine Mason", "Incorrect full name")
        XCTAssertEqual(employee.email_address, "jmason.demo@squareup.com", "Incorrect email address")
        XCTAssertEqual(employee.team, "Point of Sale", "Incorrect team")
    }
    
    func testBadJSONDecode() async throws {
        // Prepare mock response.
        // phone_number has the error
        let jsonString = """
                            {
                                "employees" : [
                                    {
                                        "uuid" : "0d8fcc12-4d0c-425c-8355-390b312b909c",

                                        "full_name" : "Justine Mason",
                                        "phone_number" :
                                        "email_address" : "jmason.demo@squareup.com",
                                        "biography" : "Engineer on the Point of Sale team.",

                                        "photo_url_small" : "https://s3.amazonaws.com/sq-mobile-interview/photos/16c00560-6dd3-4af4-97a6-d4754e7f2394/small.jpg",
                                        "photo_url_large" : "https://s3.amazonaws.com/sq-mobile-interview/photos/16c00560-6dd3-4af4-97a6-d4754e7f2394/large.jpg",

                                        "team" : "Point of Sale",
                                        "employee_type" : "FULL_TIME"
                                    }
                                ]
                            }
                         """
        let data = jsonString.data(using: .utf8)
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        
        // Call API.
        let employees = await network.fetchData()
        guard let _ = employees?[0] as? Employee else {
            XCTAssertNil(employees)
            return
        }
        XCTFail()  // Should not reach this line, if we did, our decoder is not catching the malformed json.
    }
}
