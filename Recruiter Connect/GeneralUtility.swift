//
//  GeneralUtility.swift
//  Recruiter Connect
//
//  Created by Business Career Center on 9/4/15.
//  Copyright (c) 2015 Business Career Center. All rights reserved.
//
//  This class holds different Class-level functions that are going to be 
//  extremely useful throughout the entire project.

import Foundation
import Alamofire
import UIKit

class GeneralUtility
{
    // Properties
    
    // Methods
    
    /**
     * Function for making the alamofire call to test the network
     * First create the overlay and spinner, then test the network, then remove the overlay and
     * stop the progress indicator.
     */
    class func checkNetwork(parentView : UIView, needOverlay : Bool, needSpinner : Bool, completion : ((errorFlag : Bool) -> ())?) -> Bool
    {
        // If usecase calls for overlay or spinner, create overlay and / or spinner
        if needOverlay
        {
            // Size of screen
            let screenSize : CGRect = UIScreen.mainScreen().bounds
            
            // Set up the screen overlay and the progress spinner
            let overlay             = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
            overlay.backgroundColor = UIColor(red: 223/255, green: 223/255, blue: 225/255, alpha: 0.5)
            overlay.tag             = 100
            
            parentView.addSubview(overlay)
        }
        
        if needSpinner
        {
            let spinner   = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
            spinner.frame = CGRect(x: parentView.frame.midX - 25, y: parentView.frame.midY - 100, width: 50, height: 50)
            spinner.tag   = 101
            
            parentView.addSubview(spinner)
        }
        
        // Make a network call to test the connectivity / if the REST API is available
        var errorFlag = false
        
        let endpoint = "http://recruiterconnect.byu.edu/api/menuitems/?format=json"
        
        Alamofire.request(.GET, endpoint).responseJSON
        {
            (request, response, data, error) in
            
            if let jsonData : NSArray = data as? NSArray
            {
                println("<<<<<<<<<<<<<<<<<<<<<< NETWORK TEST DATA: \(jsonData)")
            }
            
            // If there is an error, turn the boolean to false
            if let jsonError = error
            {
                println("<<<<<<<<<<<<<<<<<<<<<< NETWORK ERROR: \(jsonError)")
                errorFlag = true
            }
            
            if needOverlay
            {
                parentView.viewWithTag(100)?.removeFromSuperview()
            }
            
            if needSpinner
            {
                parentView.viewWithTag(101)?.removeFromSuperview()
            }
            
            // Call the completion handler once the request is made
            completion?(errorFlag: errorFlag)
        }
        
        return !errorFlag
    }
}