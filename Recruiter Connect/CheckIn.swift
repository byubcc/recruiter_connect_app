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
    func create(completion : ((errorFlag : Bool) -> ())?)
    {
        // Error flag
        var errorFlag = false
        
        // Create the parameters in the correct format
        let parameters =
        [
            "recruiter": "\(self.recruiter!.id!)"
        ]
        
        // Username and Password for the call
        var username = ""
        var password = ""
        
        if let recruiterEmail = self.recruiter?.email
        {
            username = recruiterEmail
        }
        
        if let recruiterPassword = self.recruiter?.password
        {
            password = recruiterPassword
        }
        
        let credentialData    = "\(username):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions(nil)
        let headers = ["Authorization":"Basic \(base64Credentials)"]
        
        let endpoint = "https://recruiterconnect.byu.edu/api/checkins/"
        // let endpoint = "http://localhost:8000/api/checkins/"
        
        // Send the request via AlamoFire
        Alamofire.request(.POST, endpoint, parameters: parameters as [String : AnyObject]?, encoding: .JSON, headers: headers).responseJSON
        {
            (request, response, data, error) in
            
            // If there's an error, print it
            if let JSONError = error
            {
                println("ERROR: \(JSONError)")
                errorFlag = true
            }
            
            // Print the data
            if let JSONData: NSDictionary = data as? NSDictionary
            {
                println("<<<<<<<<<< CHECK IN DATA: \(JSONData)")
                
                // Set the ID to the id returned
                self.id = JSONData["id"] as? Int
            }
            
            // Call the completion handler
            completion?(errorFlag : errorFlag)
        }
    }
    
    // Method for UPDATING the related object in the DB according to 
    // the attributes of the object.
    func updateDB()
    {
        
    }
    
}