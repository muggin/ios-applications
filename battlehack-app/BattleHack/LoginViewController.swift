//
//  LoginViewController.swift
//  BattleHack
//
//  Created by Alexander Juda on 25/04/15.
//  Copyright (c) 2015 Alexander Juda. All rights reserved.
//

import Foundation
class LoginViewController : UIViewController, UITextFieldDelegate, BackendConnectorDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var backendConnector: BackendConnector!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSizeMake(scrollView.bounds.width, scrollView.bounds.height * 2)
        
        backendConnector = BackendConnector(serverAddress: "http://10.205.251.112:9000")
        backendConnector.delegate = self
    }
    
    @IBAction func loginButtonTouched(sender: AnyObject) {
        var credentials = LoginCredentials(email: emailTextField.text, password: passwordTextField.text)
        backendConnector.postUser(credentials)
    }
    
    @IBAction func signupButtonTouched(sender: AnyObject) {
    }
    
    @IBAction func emailTextFieldEditingDidBegin(sender: AnyObject) {
    }
    
    @IBAction func passwordTextFieldEditingDidBegin(sender: AnyObject) {
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if (segue.identifier == "loginSegue") {
//            let destinationVC = segue.destinationViewController as! SwipeViewController
//        }
//    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
    func didPostUser() {
        performSegueWithIdentifier("loginSegue", sender: self)
    }
}