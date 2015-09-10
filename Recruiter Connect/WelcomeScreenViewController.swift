//
//  WelcomeScreenViewController.swift
//  Recruiter Connect
//
//  Created by John Duane Turner JR on 8/10/15.
//  Copyright (c) 2015 Business Career Center. All rights reserved.
//
// Contains class for the Welcome Screen view controller
//
// NOTES: This file also holds the Exit Segue that can occur from the Thank You Screen

import UIKit
import Alamofire

class WelcomeScreenViewController: UIViewController
{
    
//------------------------------------------------------------------------------------------//
//---------------------------------------- OUTLETS -----------------------------------------//
//------------------------------------------------------------------------------------------//

    // Check In Button
    @IBOutlet weak var checkInButton: UIButton!
    
    // Parent view container
    @IBOutlet var parentView: UIView!

//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
    
//------------------------------------------------------------------------------------------//
//------------------------------------ SYSTEM FUNCTIONS ------------------------------------//
//------------------------------------------------------------------------------------------//
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//

//------------------------------------------------------------------------------------------//
//-------------------------------------- NAVIGATION ----------------------------------------//
//------------------------------------------------------------------------------------------//
    
    /** 
     * Exit/Unwind Segue code
     */
    @IBAction func returnHome(segue: UIStoryboardSegue)
    {
        
    }
    
    /**
     * Test the network connection before moving on
     * 
     * Call the GeneralUtility's method for checking the network, and if it passes with no errors, 
     * then perform the appropriate segue.
     */
    @IBAction func createAccountButtonTapped(sender: AnyObject)
    {
        // Test the network
        GeneralUtility.checkNetwork(self.parentView, needOverlay: true, needSpinner: true)
        {
            (errorFlag) in
            
            // Let the user know the network is down right now
            if errorFlag
            {
                let alert = UIAlertView()
                
                alert.title   = "Network error"
                alert.message = "Please make sure you are connected to WiFi. If you are, then please try again later"
                alert.addButtonWithTitle("OK")
                
                alert.show()
            }
            else
            {
                self.performSegueWithIdentifier("toRecruiterInfo", sender: nil)
            }
        }
    }
    
    
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
    
//------------------------------------------------------------------------------------------//
//---------------------------------- OTHER USEFUL FUNCTIONS --------------------------------//
//------------------------------------------------------------------------------------------//
    
    
    
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
}
