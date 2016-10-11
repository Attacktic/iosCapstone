//
//  ViewController.swift
//  iosCapstone
//
//  Created by Adriana Galvez on 10/4/16.
//  Copyright © 2016 Adriana Galvez. All rights reserved.
//

import UIKit
var defaults = NSUserDefaults.standardUserDefaults()


class ViewController: UIViewController {
    @IBOutlet weak var Titleee: UILabel!
    @IBOutlet weak var EmailField: UITextField!
    @IBOutlet weak var NameField: UITextField!
    @IBOutlet weak var PasswordField: UITextField!
    @IBOutlet weak var AlertMessage: UILabel!
    @IBOutlet weak var CPasswordField: UITextField!
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func SignUp(sender: AnyObject) {
        if (EmailField.text == "" || NameField.text == "" || PasswordField.text == "" || CPasswordField.text == ""){
            AlertMessage.hidden = !AlertMessage.hidden
            AlertMessage.text = "Please Complete all Text Fields."
        } else {
            if (PasswordField.text! != CPasswordField.text!){
                AlertMessage.text = "Passwords don't match"
            } else {
                let request = NSMutableURLRequest(URL: NSURL(string: "https://casptonebackend.herokuapp.com/appSetUp")!)
                request.HTTPMethod = "POST"
                let postString = "email=" + EmailField.text! + "&full_name="+NameField.text!+"&password="+PasswordField.text!;
                request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
                let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
                    guard error == nil && data != nil else {
                        print("error=\(error)")
                        return
                    }
                    
                    let httpResponse = response as! NSHTTPURLResponse
                    let statusCode = httpResponse.statusCode
                    
                    if (statusCode == 200) {
                        let responseString = String(data: data!, encoding: NSUTF8StringEncoding)
                        if (responseString == "Updated user"){
                            dispatch_async(dispatch_get_main_queue(), {
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("Dashboard") as! DashController
                                self.presentViewController(nextViewController, animated:true, completion:nil)
                                
                            })
                        } else {
                            self.AlertMessage.text = responseString;
                        }
                    }
                }
                
                task.resume()
            }
        }

    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        if ((defaults.stringForKey("user")) != nil){
            dispatch_async(dispatch_get_main_queue(), {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("Dashboard") as! DashController
                self.presentViewController(nextViewController, animated:true, completion:nil)
            })
        } else {
            print("not logged in")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
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

func amPm(time: String) -> (String){
    var time = time
    let cut = time.endIndex.advancedBy(-1)
    let timefchar = time.substringToIndex(cut)
    var am = ""
    if ((timefchar == "1" ||  timefchar == "2") && time != "10" && time != "11"){
        am = "pm"
    } else {
        if(timefchar == "0"){
            time = time.substringFromIndex(cut)
        }
        am = "am"
    }
    return am
}

func prettyDate(date: String) -> (String){
    let month1 = date.endIndex.advancedBy(-6)
    let month2 = date.endIndex.advancedBy(-13)
    let cmonth = date.substringToIndex(month1)
    let month = cmonth.substringFromIndex(month2)
    let day1 = date.endIndex.advancedBy(-13)
    let day = date.substringToIndex(day1) + ordinal_suffix_of(date.substringToIndex(day1))
    let time1 = date.endIndex.advancedBy(-2)
    let time = date.substringFromIndex(time1)
    let am = amPm(time)
    let result = month + " " + day + " at " + time + am
    return result
}

extension NSDateFormatter {
    convenience init(dateFormat: String) {
        self.init()
        self.dateFormat =  dateFormat
    }
}

extension NSDate {
    struct Formatter {
        static let custom = NSDateFormatter(dateFormat: "dd-MMMM-yyyy")
    }
    var customFormatted: String {
        return Formatter.custom.stringFromDate(self)
    }
}

func today(date: String) -> (String){
    let date = NSDate().customFormatted
    return date
}

