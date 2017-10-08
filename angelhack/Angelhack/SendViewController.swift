//
//  SendViewController.swift
//  Angelhack
//
//  Created by Alexander Juda on 23/05/15.
//  Copyright (c) 2015 Alexander Juda. All rights reserved.
//

import Foundation

class SendViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var textViewBackground: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var charactersCountLabel: UILabel!
    @IBOutlet weak var boltImageView: UIImageView!
    @IBOutlet weak var importantButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var importantButtonBackground: UIView!
    
    var importantChecked = false
    
    let messageBuilder: MessageBuilder = MessageBuilder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendButton.layer.cornerRadius = CGRectGetWidth(sendButton.bounds) / 2
        sendButton.bordersWidth = 0.5
        textViewBackground.bordersWidth = 0.5
        importantButtonBackground.bordersWidth = 0.5
        
        resetTextView()
    }
    
    @IBAction func importantButtonTouched(sender: UIButton!) {
        if importantChecked {
            importantChecked = false
            boltImageView.image = UIImage(named: "bolt_inactive")
            importantButtonBackground.alpha = 0.4
            importantButton.alpha = 0.7
        } else {
            importantChecked = true
            boltImageView.image = UIImage(named: "bolt_active")
            importantButtonBackground.alpha = 1.0
            importantButton.alpha = 1.0
        }
    }
    
    @IBAction func sendButtonTouched(sender: AnyObject) {

        let messageText = textView.text
        
        // Code to check if important is selected
        var messageCategory: Message.Category
        
        if importantChecked {
            messageCategory = Message.Category.Important
        } else {
            messageCategory = Message.Category.Standard
        }
        
        if count(messageText) > 0 {
            let message = MessageBuilder.build(text: textView.text, andCategory: messageCategory, sign: false)
            let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.messageManager.sendMessage(message)
            var alertView = UIAlertView(title: nil, message: "Message sent!", delegate: nil, cancelButtonTitle: nil)
            let delay = 1.0 * Double(NSEC_PER_SEC)
            alertView.show()
            var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue(), {
                
                alertView.dismissWithClickedButtonIndex(-1, animated: true)
            })
            resetTextView()


        } else {
            UIAlertView(title: "Empty message", message: "Please add message body.", delegate: nil, cancelButtonTitle: "OK").show()
        }
    }
    
    // ----------- text view delegate
    
    
    func textViewDidBeginEditing(textView: UITextView) {
        if (textView.textColor == UIColor.lightGrayColor()) {
            textView.text = ""
            textView.textColor = UIColor.whiteColor()
        }
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if (textView.textColor == UIColor.lightGrayColor()) {
            textView.text = ""
            textView.textColor = UIColor.whiteColor()
        }
        
        return true
    }
    
    func textViewDidChange(textView: UITextView) {
        var charactersCount = count(textView.text)
        if charactersCount == 0 {
            resetTextView()
            textView.resignFirstResponder()
        } else if charactersCount >= 100 {
            textView.text = textView.text.stringByPaddingToLength(100, withString: "", startingAtIndex: 0)
            charactersCount = 100
        }
        self.charactersCountLabel.text = "\(charactersCount)/100"
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            if (count(textView.text) == 0) {
                resetTextView()
            }
            return false
        } else {
            return true
        }
    }
    
    func resetTextView() {
        textView.textColor = UIColor.lightGrayColor()
        charactersCountLabel.text = "0/100"
        textView.text = "Message here..."
    }
}