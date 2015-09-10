//
//  VehicleInfoViewController.swift
//  Recruiter Connect
//
//  Created by John Duane Turner JR on 4/2/15.
//  Copyright (c) 2015 Business Career Center. All rights reserved.
//
// This file contains the logic behind the Vehicle Info View Controller
// 
// Important Notes about this file:

import UIKit

/**
 * Protocol for passing data back and forth between this VC and the Recruiter Info
 * VC. Basically, this protocol makes it so that when a recruiter object is passed 
 * here, it will be set in the previous screen, avoiding errors that occur when the 
 * user goes back, then forward.
 **/
protocol VehicleInfoDelegate
{
    func updateRecruiterObject(recruiter : Recruiter?)
}

class VehicleInfoViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate
{
//------------------------------------------------------------------------------------------//
//--------------------------------------- OUTLETS ------------------------------------------//
//------------------------------------------------------------------------------------------//

    @IBOutlet weak var licensePlate: UITextField!
    @IBOutlet weak var carState    : UITextField!
    @IBOutlet weak var make        : UITextField!
    @IBOutlet weak var model       : UITextField!
    @IBOutlet weak var color       : UITextField!
    
    // Delegate variable
    var delegate: VehicleInfoDelegate?
    
    // Parent View of VC
    @IBOutlet var parentView: UIView!
    
    // Lunch buttons
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    // Variable to hold the PickerView that is hidden in the CarState text field
    var statePicker: UIPickerView?
    
    let stateArray =
    [
        "AK","AL","AR","AZ","CA","CO","CT","DC","DE","FL","GA","GU","HI","IA","ID","IL","IN","KS","KY",
        "LA","MA","MD","ME","MH","MI","MN","MO","MS","MT","NC","ND","NE","NH","NJ","NM","NV","NY","OH",
        "OK","OR","PA","PR","PW","RI","SC","SD","TN","TX","UT","VA","VI","VT","WA","WI","WV","WY"
    ]
    
    // Constant for the CheckIn created at this point
    var checkIn = CheckIn()
    
    // Constant for the Vehicle that we will create
    var vehicle = Vehicle()
    
    // Constant for the recruiter from the previous page to attach to the check in
    var recruiter: Recruiter?
    
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
    
//------------------------------------------------------------------------------------------//
//------------------------------------ SYSTEM FUNCTIONS ------------------------------------//
//------------------------------------------------------------------------------------------//
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Update the delegate Recruiter to avoid issues going backward
        self.delegate?.updateRecruiterObject(self.recruiter)
        
        // Set the nav bar translucent and remove the title
        self.navigationController!.navigationBar.translucent = true
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationItem.title = ""
        
        // Set up the PickerView when the CarState is selected
        self.statePicker = UIPickerView()
        
        // Set the pickerview's delegate and datasource to this view controller
        self.statePicker!.delegate   = self
        self.statePicker!.dataSource = self
        
        self.carState.inputView = statePicker
        self.carState.text      = stateArray[0]
        
        // Set the textfields' delegates to this file
        self.licensePlate.delegate = self
        self.make.delegate         = self
        self.model.delegate        = self
        self.color.delegate        = self
        
        // Set the lunch buttons' styles
        yesButton.backgroundColor    = UIColor.clearColor()
        yesButton.layer.cornerRadius = 5
        yesButton.layer.borderWidth  = 1
        yesButton.layer.borderColor  = UIColor.darkGrayColor().CGColor
        
        noButton.backgroundColor    = UIColor.clearColor()
        noButton.layer.cornerRadius = 5
        noButton.layer.borderWidth  = 1
        noButton.layer.borderColor  = UIColor.darkGrayColor().CGColor
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     * Function to move to the next UITextField when Next key is tapped
     **/
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        switch textField
        {
            case licensePlate:
                carState.becomeFirstResponder()
            case make:
                model.becomeFirstResponder()
            case model:
                color.becomeFirstResponder()
            case color:
                color.resignFirstResponder()
            default:
                textField.resignFirstResponder()
        }
        return true
    }
    
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
    
//------------------------------------------------------------------------------------------//
//-------------------------------------- NAVIGATION ----------------------------------------//
//------------------------------------------------------------------------------------------//
    
    /**
     * No Button Tapped - Check the network first, then call the segue if connected, else let the user know
     */
    @IBAction func noButtonTapped(sender: AnyObject)
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
                // Double check the fields, and if everything checks out, then
                // go ahead and move forward
                self.aboutToSegue()
                {
                    (errorFlag) in
                    if !errorFlag
                    {
                        self.performSegueWithIdentifier("toLunches", sender: nil)
                    }
                }
            }
        }
    }
    
    /**
    * Yes Button Tapped - Check the network first, then call the segue if connected, else let the user know
    */
    @IBAction func yesButtonTapped(sender: AnyObject)
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
                // Double check the fields, and if everything checks out, then 
                // go ahead and move forward
                self.aboutToSegue()
                {
                    (errorFlag) in
                    if !errorFlag
                    {
                        self.performSegueWithIdentifier("toLunches", sender: nil)
                    }
                }
            }
        }
    }
    
    /**
     * Prepare for the segue to the Duration screen by filling in the info gathered for the
     * Check In, then pass the object to the next VC
     **/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        // Check to make sure that this is the correct segue
        if segue.identifier == "toLunches"
        {
            // Pass the CheckIn object to the next VC
            let destination = segue.destinationViewController as! LunchOptionsViewController
            
            // Set the delegate
            destination.delegate = self
            destination.checkIn  = self.checkIn
        }
    }
    
    /** 
     * Check to make sure that the fields are all filled in before segue-ing
     **/
    func aboutToSegue(completion : ((errorFlag : Bool) -> ())?)
    {
        var errorFlag = false
        
        // Check to see if the text boxes are all full, if not alert the user
        if licensePlate.text.isEmpty || carState.text.isEmpty || make.text.isEmpty || model.text.isEmpty || color.text.isEmpty
        {
            // Create alert
            let alert = UIAlertView()
                
            alert.title   = "Empty Fields"
            alert.message = "Please fill in all fields on the screen before moving on."
            alert.addButtonWithTitle("OK")
                
            alert.show()
        }
        else
        {
            if self.checkIn.id == nil
            {
                // Fill in the vehicle information
                vehicle.licensePlate = self.licensePlate.text
                vehicle.carState     = self.carState.text
                vehicle.make         = self.make.text
                vehicle.model        = self.model.text
                vehicle.color        = self.color.text
                vehicle.recruiter    = self.recruiter
                
                // Create the vehicle
                vehicle.create()
                {
                    (vehicleErrorFlag) in
                    
                    if !vehicleErrorFlag
                    {
                        // Fill in the recruiter information to the check in
                        self.checkIn.recruiter = self.recruiter!
                        
                        // Create the check in
                        self.checkIn.create()
                        {
                            (checkInErrorFlag) in
                            
                            if !checkInErrorFlag
                            {
                                completion?(errorFlag: false)
                            }
                        }
                    }
                }
            }
        }
    }
    
    /**
     * Back button tapped
     **/
    @IBAction func dismiss(sender: AnyObject)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
    
//------------------------------------------------------------------------------------------//
//---------------------------------- PICKERVIEW FUNCTIONS ----------------------------------//
//------------------------------------------------------------------------------------------//
    
    /** 
     * Required method for the UIPickerViewDataSource protocol.
     * Returns the number of components for the states picker view.
     **/
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    /**
     * Required method for the UIPickerViewDataSource protocol
     * Returns the number of rows for the single component in the picker view.
     **/
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return self.stateArray.count
    }
    
    /**
     * Load in the data based on the state array
     **/
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!
    {
        return self.stateArray[row]
    }
    
    /**
     * Change the text of the text box when the a row is selected in the picker view
     **/
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.carState.text = stateArray[row]
        self.carState.resignFirstResponder()
    }
    
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//

}

//------------------------------------------------------------------------------------------//
//---------------------------------- DELEGATE EXTENSION ------------------------------------//
//------------------------------------------------------------------------------------------//

extension VehicleInfoViewController: LunchOptionsDelegate
{
    func updateCheckInObject(checkIn: CheckIn?)
    {
        // If the check in object isn't nil, then update checkin object.
        if let checkInObject = checkIn
        {
            self.checkIn = checkInObject
        }
    }
}

//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//