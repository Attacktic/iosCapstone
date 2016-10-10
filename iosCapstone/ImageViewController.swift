//
//  ImageViewController.swift
//  iosCapstone
//
//  Created by Adriana Galvez on 10/5/16.
//  Copyright © 2016 Adriana Galvez. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    var imageValue = UIImage()
    
    @IBOutlet weak var displayImage: UIImageView!
    var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.displayImage.image = imageValue
        displayImage.contentMode = .ScaleAspectFit
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var sendVal = ""
        if segue.identifier == "goBack"
        {
            let destination = segue.destinationViewController as? ActView
            var keys = Array(imagedata.keys)
            for (index, el) in imagedata.enumerate(){
                let key = keys[index]
                var el = imagedata[key]!["images"] as! [UIImage]
                for im in el {
                    if im == imageValue{
                        sendVal = key
                    }
                }
            }
            destination!.textValue = sendVal as String
        }
    }
}
