//
//  MenuItem.swift
//  Recruiter Connect
//
//  Created by John Duane Turner JR on 4/15/15.
//  Copyright (c) 2015 Business Career Center. All rights reserved.
//
//  Class for the MenuItems that are returned from the REST Call

import Foundation
import UIKit
import Alamofire

class MenuItem {
    
    // Properties
    var id              : Int?
    var name            : String?
    var defaultDressing : String?
    var photoURL        : String?
    var photo           : UIImage?
    var category        : String?
    var ingredients     : [Ingredient]?
    
    // Default initializer
    init()
    {
        
    }
    
    // Custom initializer from the REST call
    init(item : NSDictionary, completion: () -> ())
    {
        if let id = item["id"] as? Int
        {
            self.id = id
        }
        
        if let name = item["name"] as? String
        {
            self.name = name
        }
        
        if let dressing = item["default_dressing"] as? String
        {
            self.defaultDressing = dressing
        }
        
        // In setting the photo, set the "no image" photo if item doesn't have one
        if let photo = item["photo"] as? String
        {
            self.photoURL = "http://recruiterconnect.byu.edu\(photo)"
        }
        else
        {
            self.photoURL = "http://recruiterconnect.byu.edu/media/utility_images/not-available.png"
        }
        
        if let category = item["category"] as? String
        {
            self.category = category
        }
        
        if let ingredientIDs = item["ingredients"] as? [Int]
        {
            // Initialize the ingredients array
            self.ingredients = [Ingredient]()
            
            for ingredientID in ingredientIDs
            {
                // Make the Alamofire call to get the ingredient for the given ID
                // Then create the ingredient object and append it to the array of ingredients
                let ingredientEndpoint = "http://recruiterconnect.byu.edu/api/ingredients/\(ingredientID)/?format=json"
                
                Alamofire.request(.GET, ingredientEndpoint).responseJSON
                {
                    request, response, result in
                    
                    if let JSONError = result.error
                    {
                        print("<<<<<<<<<<<<<<<<<<<< INGREDIENT ERROR: \(JSONError)")
                    }
                    
                    if let JSON : NSDictionary = result.value as? NSDictionary
                    {
                        let ingredientObject = Ingredient(item: JSON)
                        self.ingredients!.append(ingredientObject)
                    }
                }
            }
        }
        
        // Alamofire call to get the images
        Alamofire.request(.GET, self.photoURL!, parameters: nil).response
            {
                request, response, result, error in
                
                if let ERROR = error
                {
                    print("<<<<<<<<<<<<<<<<<<< IMAGE ERROR: \(ERROR)")
                }
                
                if let image = result
                {
                    self.photo = UIImage(data : image)
                }
                
                completion()
        }
    }
}