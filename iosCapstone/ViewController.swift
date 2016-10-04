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
    @IBOutlet weak var PhoneField: UITextField!
    @IBOutlet weak var PasswordField: UITextField!
    @IBOutlet weak var AlertMessage: UILabel!
    @IBOutlet weak var CPasswordField: UITextField!
    
    @IBAction func SignUp(sender: AnyObject) {
        if (EmailField.text == "" || PhoneField.text == "" || NameField.text == "" || PasswordField.text == "" || CPasswordField.text == ""){
            AlertMessage.text = "Please Complete all Text Fields."
        } else {
            if (PasswordField.text! != CPasswordField.text!){
                AlertMessage.text = "Passwords don't match"
            } else {
                let request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:3000/appSetUp")!)
                request.HTTPMethod = "POST"
                let postString = "email=" + EmailField.text! + "&full_name="+NameField.text!+"&phone="+PhoneField.text!+"&password="+PasswordField.text!;
                //print(postString);
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
                            //redirect to users home page
                            dispatch_async(dispatch_get_main_queue(), {
                                //Code that presents or dismisses a view controller here
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
        print("main view")
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
        // Dispose of any resources that can be recreated.
    }
    
    
}

