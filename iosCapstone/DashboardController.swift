//
//  DashboardController.swift
//  iosCapstone
//
//  Created by Adriana Galvez on 10/4/16.
//  Copyright © 2016 Adriana Galvez. All rights reserved.
//

import Foundation
import UIKit
import AWSS3
var imagedata: [String: [String: Any]] = [:]
var valueToPass:String!

class DashController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imagedata.count
    }
    @IBAction func LogOut(sender: AnyObject) {
        defaults.removeObjectForKey("user")
        dispatch_async(dispatch_get_main_queue(), {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("LogIn") as! LoginController
            self.presentViewController(nextViewController, animated:true, completion:nil)
        })
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ActivityCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! ActivityCell
        var keys = Array(imagedata.keys)
        let key = keys[indexPath.row]
        keys = keys.sort({$0 < $1})
        if (imagedata[key] != nil){
            let image = imagedata[key]!["images"] as! [UIImage]
            cell.actTime.text = imagedata[key]!["date"] as? String
            if (image.count != 0){
                cell.CellImage.image = image[0]
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        print("You selected cell #\(indexPath.row)!")
        
        // Get Cell Label
        let indexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as UITableViewCell!
        var keys = Array(imagedata.keys)
        let key = keys[indexPath!.row]
        keys = keys.sort({$0 < $1})
        let sDate = (imagedata[key]!["date"] as? String)!.componentsSeparatedByString("-")[0]
        valueToPass = sDate
        performSegueWithIdentifier("viewEach", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "viewEach") {
            let destination = segue.destinationViewController as? ActView
            destination!.textValue = valueToPass as String
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagedata = [:]
        if ((defaults.stringForKey("user")) != nil){
            let request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:3000/whichUser")!)
            request.HTTPMethod = "POST"
            let postString = "email=" + defaults.stringForKey("user")!
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
                guard error == nil && data != nil else {
                    print("error=\(error)")
                    return
                }
                
                let httpResponse = response as! NSHTTPURLResponse
                let statusCode = httpResponse.statusCode
                
                if (statusCode == 200) {
                    do{
                        
                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                        
                        if (json.count == 0){
                            print("not found")
                        } else {
                            if let data = json as? NSArray {
                                var user_key:String!
                                user_key = "appnamezpco1ae76f3t"
                                let credentialsProvider = AWSStaticCredentialsProvider(accessKey: "AKIAIYBDS3NHZ2AIPZ2A", secretKey: "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")
                                let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: credentialsProvider)
                                AWSS3.registerS3WithConfiguration(configuration, forKey: user_key)
                                let s3 = AWSS3.S3ForKey(user_key)
                                
                                let listRequest: AWSS3ListObjectsRequest = AWSS3ListObjectsRequest()
                                listRequest.bucket = user_key
                                
                                s3.listObjects(listRequest).continueWithBlock { (task) -> AnyObject? in
                                    let listObjectsOutput = task.result;
                                    for object in (listObjectsOutput?.contents)! {
                                        let img_key = object.key!
                                        let date = img_key.componentsSeparatedByString("-")[0]
                                        if (imagedata[date] != nil){
                                            let i = imagedata[date]!["count"] as! Int
                                            
                                            imagedata[date]!["count"] = i + 1
                                        } else {
                                            imagedata[date] = [
                                                "count": 1,
                                                "date": img_key,
                                                "images": [UIImage]()
                                            ]
                                        }
                                        
                                        let s3URL = NSURL(string: "https://s3.amazonaws.com/\(user_key)/\(object.key!)")!
                                        let imageData = NSData(contentsOfURL: s3URL)
                                        if let downloadedImageData = imageData
                                        {
                                            dispatch_async(dispatch_get_main_queue()) {
                                                let image = UIImage(data: downloadedImageData)
                                                var array = imagedata[date]!["images"] as! [UIImage]
                                                if !array.contains(image!) {
                                                    array.append(image!)
                                                }
                                                imagedata[date]!["images"] = array
                                                self.tableView?.reloadData()
                                            }
                                        } else {
                                        }
                                    }
                                    return nil
                                }
                            }
                        }
                    }catch {
                        print("Error with Json: \(error)")
                    }
                }
            }
            task.resume()
            
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("Login") as! LoginController
                self.presentViewController(nextViewController, animated:true, completion:nil)
            })
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}