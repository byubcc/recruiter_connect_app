//
//  LoginViewController.swift
//  Recruiter Connect
//
//  Created by John Duane Turner JR on 4/2/15.
//  Copyright (c) 2015 Business Career Center. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController
{
//------------------------------------------------------------------------------------------//
//--------------------------------------- OUTLETS ------------------------------------------//
//------------------------------------------------------------------------------------------//
    
    // Buttons on modal
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    // Text fields
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
    
//------------------------------------------------------------------------------------------//
//------------------------------------ SYSTEM FUNCTIONS ------------------------------------//
//------------------------------------------------------------------------------------------//
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Set the style for the buttons
        self.cancelButton.backgroundColor    = UIColor.clearColor()
        self.cancelButton.layer.cornerRadius = 5
        self.cancelButton.layer.borderWidth  = 1
        self.cancelButton.layer.borderColor  = UIColor.darkGrayColor().CGColor
        
        self.logInButton.backgroundColor    = UIColor.clearColor()
        self.logInButton.layer.cornerRadius = 5
        self.logInButton.layer.borderWidth  = 1
        self.logInButton.layer.borderColor  = UIColor.darkGrayColor().CGColor
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
     * Action for dismissing the modal
     */
    @IBAction func dismiss(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
     * Log into the system - 
     * First check that the fields are filled out. If they are, check the network connectivity, 
     * if the connectivity works, then hit the server and check that the credentials work.
     */
    @IBAction func logInButtonTapped(sender: AnyObject)
    {
        // First make sure the fields are filled
        if emailField.text.isEmpty || emailField.text.isEmpty
        {
            // Let the user know that they need to fill in the text fields
            let alert = UIAlertView()
            
            alert.title   = "Empty Fields"
            alert.message = "Please fill in all fields on the screen before moving on."
            alert.addButtonWithTitle("OK")
            
            alert.show()
        }
        else
        {
            // Test the network connectivity
            GeneralUtility.checkNetwork(nil, needOverlay: false, needSpinner: false)
            {
                (errorFlag) in
                
                if errorFlag
                {
                    // Let the user know the network is down right now
                    let alert = UIAlertView()
                    
                    alert.title   = "Network error"
                    alert.message = "Please make sure you are connected to WiFi. If you are, then please try again later"
                    alert.addButtonWithTitle("OK")
                    
                    alert.show()
                }
                else
                {
                    // Log them in
                    GeneralUtility.authenticateRecruiter(self.emailField.text, password: self.passwordField.text)
                    {
                        (errorFlag) in
                        
                        // If there's an error, set up an alert
                        if errorFlag
                        {
                            // Let the user know the network is down right now
                            let alert = UIAlertView()
                            
                            alert.title   = "Wrong Username/Password"
                            alert.message = "This username/password combination isn't in our system. Please try again."
                            alert.addButtonWithTitle("OK")
                            
                            alert.show()
                        }
                        else
                        {
                            self.dismiss(self)
                        }
                    }
                }
            }
        }
    }
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//

}
