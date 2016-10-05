//
//  ImageViewController.swift
//  iosCapstone
//
//  Created by Adriana Galvez on 10/5/16.
//  Copyright © 2016 Adriana Galvez. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var displayImage: UIImageView!
    var image = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.displayImage.image = self.image
    }
}
