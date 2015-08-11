//
//  Recruiter.swift
//  Recruiter Connect
//
//  Created by John Duane Turner JR on 4/20/15.
//  Copyright (c) 2015 Business Career Center. All rights reserved.
//
//  Class for the Recruiter Objects.

import Foundation
import Alamofire

class Recruiter
{
    // Properties
    var id: Int?
    var company: Company?
    var password: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var photo: String?
    let groups = "4"
    
    // Default Initializer
    init()
    {
        self.password = "Derikismyfavorite1"
        self.firstName = "John"
        self.lastName = "Doe"
        self.email = "recruitersupport9@byu.edu"
    }
    
    // Custom Initializer
    init(recruiter: NSDictionary)
    {
        if let company = recruiter["company"] as? Company
        {
            self.company = company
        }
        
        if let firstName = recruiter["first_name"] as? String
        {
            self.firstName = firstName
        }
        
        if let lastName = recruiter["last_name"] as? String
        {
            self.lastName = lastName
        }
        
        if let email = recruiter["email"] as? String
        {
            self.email = email
        }
        
        if let photo = recruiter["photo"] as? String
        {
            self.photo = photo
        }
    }
    
    // Method for CREATING a new object in the DB according to
    // attributes of this object
    func create()
    {
        // Create the parameters in the correct format
        let parameters =
        [
            "first_name": self.firstName!,
            "last_name": self.lastName!,
            "password": self.password!,
            "email": self.email!,
            "company": String(self.company!.id!),
        ]
        
        println("PARAMETERS: \(parameters)")
        
        let endpoint = "http://recruiterconnect.byu.edu/api/recruiters/"
        // let endpoint = "http://localhost:8000/api/recruiters/"
        
        // Send the request via Alamofire
        Alamofire.request(.POST, endpoint, parameters: parameters, encoding: .JSON).responseJSON
        {
            (request, response, data, error) in
                
            println("REQUEST: \(request)")
            println("RESPONSE: \(response)")
                
            // if there's an error, print it
            if let JSONError = error
            {
                println("ERROR: \(JSONError)")
            }
                
            // Print the data
            if let JSONData: NSDictionary = data as? NSDictionary
            {
                println("<<<<<<<<<< RECRUITER DATA: \(JSONData)")
                    
                // Set the ID
                self.id = JSONData["id"] as? Int
            }
        }
        
    }
    
    // Method for UPDATING the related object in the DB according
    // to the attributes of this object
    func updateDB()
    {
        
    }
}