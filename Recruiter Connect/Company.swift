//
//  Company.swift
//  Recruiter Connect
//
//  Created by John Duane Turner JR on 4/14/15.
//  Copyright (c) 2015 Business Career Center. All rights reserved.
//
//  Class for the companies that are returned by the REST call

import Foundation
import Alamofire

class Company {
    
    // Properties
    var id   : Int?
    var name : String?
    
    // Default initializer
    init()
    {
        self.name = "Did not receive name"
    }
    
    // Custom Initializer - JSON
    init(item: NSDictionary)
    {
        if let i = item["id"] as? Int
        {
            self.id = i
        }
        if let n = item["name"] as? String
        {
            self.name = n
        }
    }
    
    // Custom initializer - String
    init(name: String)
    {
        self.name = name
    }
    
    // Method to create new Company in DB
    func create(completion: () -> Void)
    {
        // Variable for the error flag
        var errorFlag = false
        
        // Create the parameters to pass into the POST call
        let parameters =
        [
            "name": self.name!
        ]
        
        let endpoint = "https://recruiterconnect.byu.edu/api/companies/"
        // let endpoint = "http://localhost:8000/api/companies/"
        
        // Send the request via Alamofire
        Alamofire.request(.POST, endpoint, parameters: parameters, encoding: .JSON).responseJSON
        {
            (request, response, data, error) in
                
            println("RESPONSE: \(response)")
            println("REQUEST: \(request)")
                
            // If there's an error, print it
            if let JSONError = error
            {
                println("ERROR: \(JSONError)")
                    
                errorFlag = true
            }
                
            // Print the data
            if let JSONData: NSDictionary = data as? NSDictionary
            {
                println("<<<<<<<<<< COMPANY DATA: \(JSONData)")
                    
                // Call the completion handler
                completion()
            }
        }
    }
}