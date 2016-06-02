//
//  extensionImageView.swift
//  HelpMe
//
//  Created by dgallego on 2/2/16.
//  Copyright © 2016 webseoglobal. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func downloadImageFrom(link link:String, contentMode: UIViewContentMode) {
        NSURLSession.sharedSession().dataTaskWithURL( NSURL(string:link)!, completionHandler: {
            (data, response, error) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                self.contentMode =  contentMode
                if let data = data { self.image = UIImage(data: data) }
            }
        }).resume()
    }
}

