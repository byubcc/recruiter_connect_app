//
//  ImageLoader.swift
//  Recruiter Connect
//
//  Created by John Duane Turner JR on 4/15/15.
//  Copyright (c) 2015 Business Career Center. All rights reserved.
//
//  Class to download images asyncronously given a URL, including a cache.
//
// Credit to Daniel Sattler (from Team Treehouse) for source code

import Foundation
import UIKit

class ImageLoader
{
    // Properties
    var cache = NSCache()
    
    class var sharedLoader: ImageLoader
    {
        struct Static
        {
            static let instance: ImageLoader = ImageLoader()
        }
        return Static.instance
    }
    
    // Methods
    func imageForUrl(urlString: String, completionHandler:(image: UIImage?, url: String) -> ())
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),
        {
            () in
            var data: NSData? = self.cache.objectForKey(urlString) as? NSData
            
            if let goodData = data
            {
                let image = UIImage(data: goodData)
                dispatch_async(dispatch_get_main_queue(),
                {
                    () in
                    completionHandler(image: image, url: urlString)
                })
                return
            }
            
            var downloadTask: NSURLSessionDataTask = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: urlString)!, completionHandler: {(data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
                if(error != nil)
                {
                    completionHandler(image: nil, url: urlString)
                    return
                }
                
                if data != nil
                {
                    let image = UIImage(data: data)
                    self.cache.setObject(data, forKey: urlString)
                    dispatch_async(dispatch_get_main_queue(),
                    {
                        () in
                        completionHandler(image: image, url: urlString)
                    })
                    return
                }
            })
            downloadTask.resume()
        })
    }
}