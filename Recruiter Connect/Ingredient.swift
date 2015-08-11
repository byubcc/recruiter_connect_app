//
//  Ingredient.swift
//  Recruiter Connect
//
//  Created by John Duane Turner JR on 8/1/15.
//  Copyright (c) 2015 Business Career Center. All rights reserved.
//
//  Class to hold the Ingredients used by the menu items

import Foundation
import Alamofire

class Ingredient
{
    // Properties
    var id       : Int?
    var name     : String?
    var category : String?
    
    // Default initializer
    init()
    {
        
    }
    
    /**
     * Custom initializer to use with the REST call
     */
    init(item : NSDictionary)
    {
        if let id = item["id"] as? Int
        {
            self.id = id
        }
        
        if let name = item["name"] as? String
        {
            self.name = name
        }
        
        if let category = item["category"] as? String
        {
            self.category = category
        }
    }
}