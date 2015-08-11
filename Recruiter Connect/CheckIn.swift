//
//  CheckIn.swift
//  Recruiter Connect
//
//  Created by John Duane Turner JR on 4/23/15.
//  Copyright (c) 2015 Business Career Center. All rights reserved.
//
//  Class for CheckIns.

import Foundation
import Alamofire

class CheckIn
{
    // Properties
    var id        : Int?
    var recruiter : Recruiter?
    
    // Init method
    init()
    {

    }

    // Method for CREATING a new object in the DB according to 
    // attributes of this object
    func create()
    {
        // Create the parameters in the correct format
        let parameters =
        [
            "recruiter": "\(self.recruiter!.id!)"
        ]
        
        let endpoint = "http://recruiterconnect.byu.edu/api/checkins/"
        // let endpoint = "http://localhost:8000/api/checkins/"
        
        // Send the request via AlamoFire
        Alamofire.request(.POST, endpoint, parameters: parameters as [String : AnyObject]?, encoding: .JSON).responseJSON
        {
            (request, response, data, error) in
            
            // If there's an error, print it
            if let JSONError = error
            {
                println("ERROR: \(JSONError)")
            }
            
            // Print the data
            if let JSONData: NSDictionary = data as? NSDictionary
            {
                println("<<<<<<<<<< CHECK IN DATA: \(JSONData)")
                
                // Set the ID to the id returned
                self.id = JSONData["id"] as? Int
            }
        }
    }
    
    // Method for UPDATING the related object in the DB according to 
    // the attributes of the object.
    func updateDB()
    {
        
    }
    
}