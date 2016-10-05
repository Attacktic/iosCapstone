//
//  ActView.swift
//  iosCapstone
//
//  Created by Adriana Galvez on 10/4/16.
//  Copyright © 2016 Adriana Galvez. All rights reserved.
//

import Foundation
import UIKit

class ActView: UIViewController {
    var textValue: String = ""
    @IBOutlet weak var actTitle: UILabel!
    
    override func viewDidLoad() {
        print("active")
        actTitle.text = textValue
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}