//
//  DessertSelectionViewController.swift
//  Recruiter Connect
//
//  Created by John Duane Turner JR on 8/11/15.
//  Copyright (c) 2015 Business Career Center. All rights reserved.
//

import UIKit

class DessertSelectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{

//------------------------------------------------------------------------------------------//
//---------------------------------------- OUTLETS -----------------------------------------//
//------------------------------------------------------------------------------------------//

    var desserts = [Dessert]()
    
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
    
//------------------------------------------------------------------------------------------//
//------------------------------------ SYSTEM FUNCTIONS ------------------------------------//
//------------------------------------------------------------------------------------------//

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    */
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.desserts.count
    }
    
    /**
    * Returns the cell for a given index path
    */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        // Set the cell
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("dessertCell", forIndexPath: indexPath) as! DessertCell
        
        // Change the label to be the name of the menu item
        cell.label.text = self.desserts[indexPath.item].name
            
        // Make sure the item has a URL for the photo, and if so, grab the corresponding image from the
        // pre-populated dictionaries
        if let image: UIImage = self.desserts[indexPath.item].photo
        {
            cell.image.image = image
        }
        
        
        return cell
    }
    
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
//------------------------------------------------------------------------------------------//
    
}
