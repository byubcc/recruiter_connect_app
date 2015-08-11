//
//  Vehicle.swift
//  Recruiter Connect
//
//  Created by John Duane Turner JR on 7/30/15.
//  Copyright (c) 2015 Business Career Center. All rights reserved.
//

import Foundation
import Alamofire

class Vehicle
{
    // Properties
    var id           : Int?
    var licensePlate : String?
    var carState     : String?
    var make         : String?
    var model        : String?
    var color        : String?
    var recruiter    : Recruiter?
    
    // Init method
    init()
    {
        
    }
    
    // Method for CREATING a new object in the DB according to the attributes
    func create()
    {
        let parameters =
        [
            "license_plate" : self.licensePlate!,
            "car_state"     : self.carState!,
            "make"          : self.make!,
            "model"         : self.model!,
            "color"         : self.color!,
            "recruiter"     : String(self.recruiter!.id!)
        ]
        
        let endpoint = "http://recruiterconnect.byu.edu/api/vehicles/"
        // let endpoint = "http://localhost:8000/api/vehicles/"
        
        // Send the request via AlamoFire
        Alamofire.request(.POST, endpoint, parameters: parameters as [String : AnyObject]?, encoding: .JSON).responseJSON
        {
            (_, _, data, error) in
                
            // If there's an error, Print it
            if let JSONError = error
            {
                println("<<<<<<<<ERROR: \(JSONError)")
            }
                
            // Print data received
            if let JSONData:NSDictionary = data as? NSDictionary
            {
                println("<<<<<<<<<< VEHICLE DATA: \(JSONData)")
                
                // Set the id for use later
                self.id = JSONData["id"] as? Int
            }
                
        }
    }
}