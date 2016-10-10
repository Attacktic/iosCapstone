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
    
    func ordinal_suffix_of(i: String) -> (String){
        let date = Int(i)
        let j = date! % 10,
        k = date! % 100;
        if (j == 1 && k != 11) {
        return "st";
        }
        if (j == 2 && k != 12) {
        return "nd";
        }
        if (j == 3 && k != 13) {
        return "rd";
        }
        return "th";
    }

    func prettyDate(date: String) -> (String){
        let month1 = date.endIndex.advancedBy(-6)
        let month2 = date.endIndex.advancedBy(-13)
        let cmonth = date.substringToIndex(month1)
        let month = cmonth.substringFromIndex(month2)
        let day1 = date.endIndex.advancedBy(-13)
        let day = date.substringToIndex(day1) + ordinal_suffix_of(date.substringToIndex(day1))
        let time1 = date.endIndex.advancedBy(-2)
        var am = ""
        var time = date.substringFromIndex(time1)
        let cut = time.endIndex.advancedBy(-1)
        let timefchar = time.substringToIndex(cut)
        print("TIMEEEE")
        print(time)
        if ((timefchar == "1" ||  timefchar == "2") && time != "12" && time != "10" && time != "11"){
            am = "pm"
        } else {
            if(timefchar == "0"){
                time = time.substringFromIndex(cut)
            }
            am = "am"
        }
        let result = month + " " + day + " at " + time + am
        return result
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