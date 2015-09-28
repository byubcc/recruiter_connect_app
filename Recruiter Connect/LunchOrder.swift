//
//  LunchOrder.swift
//  Recruiter Connect
//
//  Created by John Duane Turner JR on 4/23/15.
//  Copyright (c) 2015 Business Career Center. All rights reserved.
//
//  Class for the lunch orders placed by the recruiter

import Foundation
import Alamofire
import UIKit

class LunchOrder
{
    // Properties
    var id            : Int?
    var dessert       : Dessert?
    var menuItem      : MenuItem?
    var ingredients   : [Ingredient]?
    var saladDressing : SaladDressing?
    var checkIn       : CheckIn?
    
    /**
     * Default Initializer
     */
    init()
    {
        
    }
    
    /**
     * Function to create lunch order in DB
     */
    func create(completion: ((errorFlag : Bool, alert : UIAlertView) -> ())?)
    {
        // Error flag variable and message
        var errorFlag = false
        let alert     = UIAlertView()
        
        // First get the ingredients based on the array of ingredients
        var ingredientsJSON = [String]()
        
        if let ingredientsArray = self.ingredients
        {
            for ingredient in ingredientsArray
            {
                ingredientsJSON.append(String(ingredient.id!))
            }
        }
        
        // Then get the salad dressing, if there is one
        var salad_dressing = ""
        
        if let dressing = self.saladDressing
        {
            salad_dressing = String(dressing.id!)
        }
        
        // Set the properties
        let parameters =
        [
            "dessert"        : String(self.dessert!.id!),
            "menu_item"      : String(self.menuItem!.id!),
            "ingredients"    : ingredientsJSON,
            "salad_dressing" : salad_dressing,
            "check_in"       : String(self.checkIn!.id!)
        ]
        
        // Username and Password for the call
        var username = ""
        var password = ""
        
        if let recruiterEmail = self.checkIn?.recruiter?.email
        {
            username = recruiterEmail
        }
        
        if let recruiterPassword = self.checkIn?.recruiter?.password
        {
            password = recruiterPassword
        }
        
        let credentialData    = "\(username):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
        let headers           = ["Authorization":"Basic \(base64Credentials)"]
        
        // Print the credentials
        print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< LUNCH ORDER CREDENTIALS: \(username) : \(password)")
        
        // Set the endpoint
        let endpoint = "https://recruiterconnect.byu.edu/api/lunchorders/"
        // let endpoint = "http://localhost:8000/api/lunchorders/"
        
        // Send the POST request via Alamofire
        Alamofire.request(.POST, endpoint, parameters: parameters as? [String : AnyObject], encoding: .JSON, headers : headers).responseJSON
        {
            request, response, result in
            
            // If there is an error, mark the error flag and print the error
            if let ERROR = result.error
            {
                print("<<<<<<<<<< LUNCH ORDER ERROR: \(ERROR)")
                errorFlag = true
            }
            
            // Print the data for now
            if let JSON : NSDictionary = result.value as? NSDictionary
            {
                print("<<<<<<<<<< LUNCH ORDER DATA: \(JSON)")
                
                // Check that there's no authentication issues
                // If there is a key in the dictionary called "Detail" then there might be 
                // authentication issues
                if JSON.valueForKey("detail") != nil
                {
                    if JSON["detail"]!.lowercaseString.rangeOfString("Authentication credentials were not provided") != nil
                    {
                        errorFlag = true
                        
                        let alert = UIAlertView()
                        
                        alert.title   = "Authentication Problem"
                        alert.message = "Oops! Looks like something went wrong with your login credentials. Please re-login and start over!"
                        alert.addButtonWithTitle("OK")
                    }
                }
                else
                {
                    // Set the ID
                    self.id = JSON["id"] as? Int
                }
            }
            
            // Call the completion handler
            completion?(errorFlag: errorFlag, alert : alert)
        }
    }
}