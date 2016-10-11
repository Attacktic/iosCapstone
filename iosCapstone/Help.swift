//
//  Help.swift
//  iosCapstone
//
//  Created by Adriana Galvez on 10/10/16.
//  Copyright © 2016 Adriana Galvez. All rights reserved.
//

import Foundation

//
//  ImageViewController.swift
//  iosCapstone
//
//  Created by Adriana Galvez on 10/5/16.
//  Copyright © 2016 Adriana Galvez. All rights reserved.
//

import UIKit

class HelpController: UIViewController {
    
    @IBAction func ReadMe(sender: AnyObject) {
        if let url = NSURL(string: "https://github.com/Attacktic/BuzzPy") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
}