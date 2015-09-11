//
//  LunchOptionsViewController.swift
//  Recruiter Connect
//
//  Created by John Duane Turner JR on 2/4/15.
//  Copyright (c) 2015 Business Career Center. All rights reserved.
//
// This page loads the possible lunch options and formats them for the recruiter
// to use to choose what to eat for lunch. This page is only visible if the recruiter
// chooses that they want to eat lunch that day.
//
// Notes: This page hits the DB endpoint for the Lunch Menu Items, then pulls those back to
// display to the end user. 

import UIKit
import Foundation
import Alamofire

/**
 * Protocol for passing data back and forth between this VC and the Recruiter Info
 * VC. Basically, this protocol makes it so that when a recruiter object is passed
 * here, it will be set in the previous screen, avoiding errors that occur when the
 * user goes back, then forward.
 */
protocol LunchOptionsDelegate
{
    func updateCheckInObject(checkIn : CheckIn?)
}

class LunchOptionsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
//------------------------------------------------------------------------------------------//
//--------------------------------------- OUTLETS ------------------------------------------//
//------------------------------------------------------------------------------------------//
    
    // Delegate variable
    var delegate: LunchOptionsDelegate?
    
    // Outlet for the Collection View
    @IBOutlet weak var collection: UICollectionView!
    
    // Outlets for the different views that are selected
    @IBOutlet weak var sandwichView: UIView!
    @IBOutlet weak var saladView: UIView!
    @IBOutlet weak var soupView: UIView!
    
    // Parent View
    @IBOutlet var parentView: UIView!
    
    // Color of the background to use in changing the tab background
    let selectedTabColor = UIColor(red: 223/255, green: 223/255, blue: 225/255, alpha: 1.0)
    
    // Check-In object to be passed from previous screen
    var checkIn : CheckIn?
    
    // Lunch Order object to be passed in from next modal screen
    var lunchOrder : LunchOrder?
    
    // Arrays of the MenuItems
    var salads      = [MenuItem]()
    var soups       = [MenuItem]()
    var sandwiches  = [MenuItem]()

//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
    
//------------------------------------------------------------------------------------------//
//------------------------------------ SYSTEM FUNCTIONS ------------------------------------//
//------------------------------------------------------------------------------------------//
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Update the delegate CheckIn to avoid issues with the recruiter going backward
        self.delegate?.updateCheckInObject(self.checkIn)
        
        // Set the nav bar translucent and remove the title
        self.navigationController!.navigationBar.translucent = true
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationItem.title = ""
        
        // Set the border colors of the "tab" views
        self.sandwichView.layer.borderWidth = 1
        self.soupView.layer.borderWidth     = 1
        self.saladView.layer.borderWidth    = 1
        
        self.sandwichView.layer.borderColor = selectedTabColor.CGColor
        self.soupView.layer.borderColor     = selectedTabColor.CGColor
        self.saladView.layer.borderColor    = selectedTabColor.CGColor
        
        // Set the background color of the collectionview to be same color as the tabs
        self.collection.backgroundColor = selectedTabColor

        self.retrieveFoodItems()
        {
            (errorFlag) in
            if errorFlag
            {
                let alert = UIAlertView()
                
                alert.title   = "Network error"
                alert.message = "Please make sure you are connected to WiFi. If you are, then try again later"
                alert.addButtonWithTitle("OK")
                        
                alert.show()
            }
            else
            {
                // Remove the overlay and spinner
                self.parentView.viewWithTag(100)?.removeFromSuperview()
                self.parentView.viewWithTag(101)?.removeFromSuperview()
                
                // Redraw the collection based on what was brough in from REST call
                self.collection.reloadData()
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
     * Tap Gesture recognizer for the Sandwich tab:
     *
     * Changes the color of all of the other tabs to white, changes the color of the 
     * Sandwich tab to gray, and then reloads the menu item collection.
     */
    @IBAction func sandwichTabTapped(sender: AnyObject)
    {
        // Change all of the tabs to white
        changeTabsWhite()
        
        // Change the Sandwich tab to selected color
        self.sandwichView.backgroundColor = selectedTabColor
        
        // Redraw the collectionview
        collection.reloadData()
    }
    
    /**
    * Tap Gesture recognizer for the Salad tab
    *
    * Changes the color of all of the other tabs to white, changes the color of the
    * Salad tab to gray, and then reloads the menu item collection.
    */
    @IBAction func saladTabTapped(sender: AnyObject)
    {
        // Change all of the tabs to white
        changeTabsWhite()
        
        // Change the Sandwich tab to selected color
        self.saladView.backgroundColor = selectedTabColor
        
        // Redraw the collectionview
        collection.reloadData()
    }
    
    /**
    * Tap Gesture recognizer for the Soups tab
    *
    * Changes the color of all of the other tabs to white, changes the color of the
    * Soup tab to gray, and then reloads the menu item collection.
    */
    @IBAction func soupTabTapped(sender: AnyObject)
    {
        // Change all of the tabs to white
        changeTabsWhite()
        
        // Change the Sandwich tab to selected color
        self.soupView.backgroundColor = selectedTabColor
        
        // Redraw the collectionview
        collection.reloadData()
    }
    
    /**
     * Prepare for the segue by grabbing the selected item and passing it into the lunch
     * details page
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "showLunchDetails"
        {
            // Get the index path from the sender that was passed in
            let indexPath: NSIndexPath = sender as! NSIndexPath
            
            // Create variable for the menu item to pass in
            var selectedItem = MenuItem()
            
            // Choose a menu item based on the section that the index path indicates
            if sandwichView.backgroundColor == selectedTabColor
            {
                selectedItem = sandwiches[indexPath.item]
            }
            else if saladView.backgroundColor == selectedTabColor
            {
                selectedItem = salads[indexPath.item]
            }
            else if soupView.backgroundColor == selectedTabColor
            {
                selectedItem = soups[indexPath.item]
            }
            
            // Pass data to the next VC
            let nextVC = segue.destinationViewController as! LunchDetailsViewController
            
            nextVC.menuItem = selectedItem
            nextVC.checkIn  = self.checkIn!
            nextVC.delegate = self
        }
        else if segue.identifier == "showDessertsSelection"
        {
            // Set the next view controller's lunch order
            let nextVC = segue.destinationViewController as! DessertSelectionViewController
            
            nextVC.lunchOrder = self.lunchOrder
            nextVC.delegate   = self
        }
    }
    
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
    
//------------------------------------------------------------------------------------------//
//-------------------------------- COLLECTION VIEW FUNCTIONS -------------------------------//
//------------------------------------------------------------------------------------------//
    
    /** 
     * Returns number of sections in the collection view
     */
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    /**
    * Returns the number of cells to be created in the collection view
    * based on which "tab" view is colored correctly
    */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        // Test to see which view is selected and return the number corresponding
        if sandwichView.backgroundColor!.isEqual(selectedTabColor)
        {
            return sandwiches.count
        }
        else if saladView.backgroundColor!.isEqual(selectedTabColor)
        {
            return salads.count
        }
        else
        {
            return soups.count
        }
    }

    /**
    * Returns the cell for a given index path
    */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        // Set the cell
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("menuCell", forIndexPath: indexPath) as! MenuCell
        
        var menuItem = MenuItem()
        
        // Depending on what "tab" view is selected (ie. which tab is colored)
        if sandwichView.backgroundColor!.isEqual(selectedTabColor)
        {
            menuItem = sandwiches[indexPath.item]
        }
        else if saladView.backgroundColor!.isEqual(selectedTabColor)
        {
            menuItem = salads[indexPath.item]
        }
        else
        {
            menuItem = soups[indexPath.item]
        }
        
        // Change the label to be the name of the menu item
        cell.label.text = menuItem.name
        
        // Make sure the item has a URL for the photo, and if so, grab the corresponding image from the 
        // pre-populated dictionaries
        if let image: UIImage = menuItem.photo
        {
            cell.image.image = image
        }
        
        return cell
    }
    
    /**
     * Function for when lunch item is tapped - checks the network connection first
     * If it's there, perform the segue
     */
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
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
                // Call the segue and pass the index path
                self.performSegueWithIdentifier("showLunchDetails", sender: indexPath)
            }
        }
    }
    
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
    
//------------------------------------------------------------------------------------------//
//--------------------------------- OTHER USEFUL FUNCTIONS ---------------------------------//
//------------------------------------------------------------------------------------------//
    
    /**
     * Make the Alamofire request for the menu items
     */
    func retrieveFoodItems(completion: (Bool) -> Void)
    {
        // First set up a loading overlay and spinner
        // Size of screen
        let screenSize : CGRect = UIScreen.mainScreen().bounds
        
        // Set up the screen overlay and the progress spinner
        let overlay             = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        overlay.backgroundColor = UIColor(red: 223/255, green: 223/255, blue: 225/255, alpha: 0.5)
        overlay.tag             = 100
        
        self.parentView.addSubview(overlay)
        
        let spinner   = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        spinner.frame = CGRect(x: self.parentView.frame.midX - 25, y: self.parentView.frame.midY - 100, width: 50, height: 50)
        spinner.tag   = 101
        
        self.parentView.addSubview(spinner)
        
        // Start animating
        spinner.startAnimating()
        
        // Attempt to make the GET call via Alamofire
        let endpoint = "https://recruiterconnect.byu.edu/api/menuitems/?format=json"
        // let endpoint = "http://localhost:8000/api/menuitems/?format=json"
        
        var errorFlag = false
        
        // Make the GET request via AlamoFire
        Alamofire.request(.GET, endpoint).responseJSON
        {
            (request, response, data, error) in
            
            // Reinitialize the arrays, just in case the view is shown again
            self.salads      = [MenuItem]()
            self.soups       = [MenuItem]()
            self.sandwiches  = [MenuItem]()
        
            // If there's an error, print it
            if let JSONError = error
            {
                println(JSONError)
                errorFlag = true
            }
        
            // Unwrap the data into a NSArray
            if let json: NSArray = data as? NSArray
            {
                // Populate the different lunch arrays based on their categories
                for item in json
                {
                    var option = MenuItem(item: item as! NSDictionary)
                    {
                        self.collection.reloadData()
                    }
        
                    if option.category?.lowercaseString == "soup"
                    {
                        self.soups.append(option)
                    }
                    else if option.category?.lowercaseString == "sandwich"
                    {
                        self.sandwiches.append(option)
                    }
                    else if option.category?.lowercaseString == "salad"
                    {
                        self.salads.append(option)
                    }
                }
            }
            else
            {
                errorFlag = true
            }
            completion(errorFlag)
        }

    }
    
    /**
     * Changes all of the tabs to white (used often in the tap gesture recognizers)
     */
    func changeTabsWhite()
    {
        self.sandwichView.backgroundColor = UIColor.whiteColor()
        self.soupView.backgroundColor     = UIColor.whiteColor()
        self.saladView.backgroundColor    = UIColor.whiteColor()
    }
    
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
}

//------------------------------------------------------------------------------------------//
//---------------------------------- DELEGATE EXTENSION ------------------------------------//
//------------------------------------------------------------------------------------------//

extension LunchOptionsViewController: LunchDetailsDelegate, DessertSelectionDelegate
{
    func dismissLunchDetails(lunchOrder: LunchOrder?)
    {
        // Receive the lunchOrder object and pass it to the next modal
        
        println("<<<<<<<<<<<<<<< GOT INTO THE DELEGATE METHOD")
        
        self.lunchOrder = lunchOrder
        
        performSegueWithIdentifier("showDessertsSelection", sender: self)
    }
    
    func dismissDessertSelection()
    {
        // Perform the segue to the Thank You Screen
        println("<<<<<<<<<<<<<<< GOT INTO THE DELEGATE METHOD")
        
        self.performSegueWithIdentifier("toThankYouScreen", sender: self)
    }
}

//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
