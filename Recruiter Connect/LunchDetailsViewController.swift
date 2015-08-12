//
//  LunchDetailsViewController.swift
//  Recruiter Connect
//
//  Created by John Duane Turner JR on 4/15/15.
//  Copyright (c) 2015 Business Career Center. All rights reserved.
//
//  Controller for the details page for Lunch Options that a User selects.

import UIKit

class LunchDetailsViewController: UIViewController
{

//------------------------------------------------------------------------------------------//
//--------------------------------------- OUTLETS ------------------------------------------//
//------------------------------------------------------------------------------------------//
    
    // Menu item to be passed in from the previous screen
    var menuItem : MenuItem?
    
    // Check In to be passed from the previous screen
    var checkIn : CheckIn?
    
    // Lunch Order Variable
    var lunchOrder : LunchOrder?
    
    // Outlets for the Menu Item info
    @IBOutlet weak var menuItemName   : UILabel!
    @IBOutlet weak var menuItemImage  : UIImageView!
    @IBOutlet weak var customizeLabel : UILabel!
    
    // Array to hold the eventual UISwitches associated with the ingredients
    var ingredientSwitchArray = [UISwitch]()
    
    // Views that act as UI element containers
    @IBOutlet weak var ingredientsContainer: UIView!
    
    // Constants for the correct font and text color to be used
    let smallFont        = UIFont(name: "HelveticaNeue-Thin", size: 14.0)
    let largerFont       = UIFont(name: "HelveticaNeue-Thin", size: 30.0)
    let textColor        = UIColor(red: 78/255, green: 108/255, blue: 163/255, alpha: 1)
    let selectedTabColor = UIColor(red: 223/255, green: 223/255, blue: 225/255, alpha: 1.0)
    
    // Button outlets
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var selectButton: UIButton!
    
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
    
//------------------------------------------------------------------------------------------//
//------------------------------------ SYSTEM FUNCTIONS ------------------------------------//
//------------------------------------------------------------------------------------------//
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Change the title of the page based on the MenuItem passed in
        menuItemName.text = menuItem?.name
        
        // Assign the menu item image to the UIImageView
        menuItemImage.image = menuItem?.photo
        
        // Set the button's styles
        // Set the lunch buttons' styles
        self.cancelButton.backgroundColor    = UIColor.clearColor()
        self.cancelButton.layer.cornerRadius = 5
        self.cancelButton.layer.borderWidth  = 1
        self.cancelButton.layer.borderColor  = UIColor.darkGrayColor().CGColor
        
        self.selectButton.backgroundColor    = UIColor.clearColor()
        self.selectButton.layer.cornerRadius = 5
        self.selectButton.layer.borderWidth  = 1
        self.selectButton.layer.borderColor  = UIColor.darkGrayColor().CGColor
        
        // Create the Switches and labels for the ingredients
        // If there are no ingredients (eg. soups), then make the "Customize your order label dissappear
        if let ingredientsArray = menuItem?.ingredients
        {
            if ingredientsArray.count == 0
            {
                self.customizeLabel.text = ""
            }
            else
            {
                // Variables for the x and y for the labels
                var labelXCol1  : CGFloat = 65
                var labelXCol2  : CGFloat = 210
                var labelXCol3  : CGFloat = 360
                var labelY      : CGFloat = 15
                var labelWidth  : CGFloat = 80
                var labelHeight : CGFloat = 50
                
                // Variables for the x and y for the UISwitches
                var switchXCol1 : CGFloat = 5
                var switchXCol2 : CGFloat = 150
                var switchXCol3 : CGFloat = 300
                var switchY     : CGFloat = 25
                
                // Counter to change the x value based on the column
                var counter = 1
                
                for ingredient in ingredientsArray
                {
                    // Create the switch
                    let ingredientSwitch = UISwitch()
                    ingredientSwitch.on  = true
                    
                    // Append it to the array
                    self.ingredientSwitchArray.append(ingredientSwitch)
                    
                    // Create the Label
                    let ingredientName           = UILabel()
                    ingredientName.text          = ingredient.name
                    ingredientName.font          = self.smallFont
                    ingredientName.textColor     = self.textColor
                    ingredientName.numberOfLines = 3
                    ingredientName.lineBreakMode = NSLineBreakMode.ByWordWrapping
                    
                    // Set the size and location based on the counter
                    if counter % 3 == 0
                    {
                        ingredientSwitch.frame = CGRectMake(switchXCol3, switchY, 33, 20)
                        ingredientName.frame   = CGRectMake(labelXCol3, labelY, labelWidth, labelHeight)
                        labelY                 += 50
                        switchY                += 50
                    }
                    else if counter % 3 == 1
                    {
                        ingredientSwitch.frame = CGRectMake(switchXCol1, switchY, 33, 20)
                        ingredientName.frame   = CGRectMake(labelXCol1, labelY, labelWidth, labelHeight)
                    }
                    else
                    {
                        ingredientSwitch.frame = CGRectMake(switchXCol2, switchY, 33, 20)
                        ingredientName.frame   = CGRectMake(labelXCol2, labelY, labelWidth, labelHeight)
                    }
                    
                    // Set the label
                    self.ingredientsContainer.addSubview(ingredientName)
                    self.ingredientsContainer.addSubview(ingredientSwitch)
                    
                    // Increment the y values and the counter
                    counter += 1
                }
            }
        }
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
     * Select button tapped - Create the lunch order object, dismiss this modal, 
     * and pass the necessary objects to the next dessert modal
     */
    @IBAction func selectButtonTapped(sender: AnyObject)
    {
        // Initialize the lunch order object and associate it with the info from the user
        self.lunchOrder = LunchOrder()
        
        self.lunchOrder?.menuItem    = self.menuItem!
        self.lunchOrder?.checkIn     = self.checkIn!
        self.lunchOrder?.ingredients = [Ingredient]()
        
        // Get the ingredients if there are any, and determine which ones to add from which ones are 
        // actually selected
        if let ingredientsArray = self.menuItem?.ingredients
        {
            for (index, ingredientSwitch) in enumerate(ingredientSwitchArray)
            {
                if ingredientSwitch.on
                {
                    self.lunchOrder?.ingredients?.append(ingredientsArray[index])
                }
            }
        }
        
        // Dismiss this VC and call the next VC 
        self.dismissViewControllerAnimated(true)
        {
            let ownerVC   = self.parentViewController
            let dessertVC = DessertSelectionViewController()
            
            dessertVC.lunchOrder = self.lunchOrder
            
            ownerVC?.presentViewController(dessertVC, animated: true, completion: nil)
        }
    }
    
    /**
     * Cancel Button Tapped - dismiss the modal so user can select another option
     */
    @IBAction func cancelButtonTapped(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//


    
}
