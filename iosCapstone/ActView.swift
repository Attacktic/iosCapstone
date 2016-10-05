//
//  ActView.swift
//  iosCapstone
//
//  Created by Adriana Galvez on 10/4/16.
//  Copyright © 2016 Adriana Galvez. All rights reserved.
//

import Foundation
import UIKit

class ActView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var textValue: String = ""
    var thisDisplay: [UIImage] = [ ]
    @IBOutlet weak var actTitle: UILabel!
    @IBOutlet weak var imagesCol: UICollectionView!
    
    override func viewDidLoad() {
        actTitle.text = textValue
        thisDisplay = imagedata[actTitle.text!]!["images"] as! [UIImage]
        print("TITLEEE")
        print(actTitle.text!)
        self.imagesCol?.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        actTitle.text = textValue
        //let thisDisplay = imagedata[actTitle.text!]!["images"] as! [UIImage]
        print("HOW MANY")
        print(thisDisplay)
        print(thisDisplay.count)
        return thisDisplay.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.imagesCol.dequeueReusableCellWithReuseIdentifier("imgcell", forIndexPath: indexPath) as! CollectionViewCell
        //let thisDisplay = imagedata[actTitle.text!]!["images"] as! [UIImage]
        cell.cellImage.image = thisDisplay[indexPath.row]
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}