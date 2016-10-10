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
    var thisDisplay: [UIImage] = []
    @IBOutlet weak var actTitle: UILabel!
    @IBOutlet weak var imagesCol: UICollectionView!
    
    override func viewDidLoad() {
        actTitle.text = textValue
        thisDisplay = []
        thisDisplay = imagedata[actTitle.text!]!["images"] as! [UIImage]
        print(imagedata)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        actTitle.text = prettyDate(textValue)
        return thisDisplay.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.imagesCol.dequeueReusableCellWithReuseIdentifier("imgcell", forIndexPath: indexPath) as! CollectionViewCell
        cell.cellImage.image = thisDisplay[indexPath.row]
        cell.cellImage.contentMode = .ScaleAspectFit
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showImage", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showImage"
        {
            let indexPaths = self.imagesCol!.indexPathsForSelectedItems()!
            let indexPath = indexPaths[0] as NSIndexPath
            let vc = segue.destinationViewController as! ImageViewController
            vc.imageValue = thisDisplay[indexPath.row]
            print(vc.imageValue)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}