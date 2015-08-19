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
    func create(completion: ((errorFlag : Bool) -> ())?)
    {
        // Error flag variable
        var errorFlag = false
        
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
        
        // Set the endpoint
        let endpoint = "http://recruiterconnect.byu.edu/api/lunchorders/"
        // let endpoint = "http://localhost:8000/api/lunchorders/"
        
        // Send the POST request via Alamofire
        Alamofire.request(.POST, endpoint, parameters: parameters as? [String : AnyObject], encoding: .JSON).responseJSON
        {
            (request, response, data, error) in
            
            // If there is an error, mark the error flag and print the error
            if let ERROR = error
            {
                println("<<<<<<<<<< LUNCH ORDER ERROR: \(ERROR)")
                errorFlag = true
            }
            
            // Print the data for now
            if let JSON : NSDictionary = data as? NSDictionary
            {
                println("<<<<<<<<<< LUNCH ORDER DATA: \(JSON)")
                
                // Set the ID
                self.id = JSON["id"] as? Int
            }
            
            // Call the completion handler
            completion?(errorFlag: errorFlag)
        }
    }
}