//
//  ViewController.swift
//  iosCapstone
//
//  Created by Adriana Galvez on 10/4/16.
//  Copyright © 2016 Adriana Galvez. All rights reserved.
//

import Foundation
import UIKit

class LoginController: UIViewController {

    @IBOutlet weak var EmailField: UITextField!
    @IBOutlet weak var PassField: UITextField!
    @IBOutlet weak var AlertMessage: UILabel!
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func LogIn(sender: AnyObject) {
        if (EmailField.text == "" || PassField.text == ""){
            AlertMessage.hidden = !AlertMessage.hidden
            AlertMessage.text = "Please Enter Email and Password."
        } else {
            let request = NSMutableURLRequest(URL: NSURL(string: "https://casptonebackend.herokuapp.com/login")!)
            request.HTTPMethod = "POST"
            let postString = "email=" + EmailField.text! + "&pass="+PassField.text!;
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
                    if (responseString == "Login Verified"){
                        defaults.setObject(self.EmailField.text, forKey: "user")
                        print(error)
                        dispatch_async(dispatch_get_main_queue(), {
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                            let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("Dashboard") as! DashController
                            self.presentViewController(nextViewController, animated:true, completion:nil)
                            
                        })
                    } else {
                        self.AlertMessage.text = "Email/Password Don't Match"
                    }
                }
            }
            task.resume()
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
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}