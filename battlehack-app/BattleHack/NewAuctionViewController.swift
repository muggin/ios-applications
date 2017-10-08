//
//  NewAuctionViewController.swift
//  BattleHack
//
//  Created by Alexander Juda on 25/04/15.
//  Copyright (c) 2015 Alexander Juda. All rights reserved.
//

import Foundation
import CoreLocation

class NewAuctionViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var onePoundButton: UIButton!
    @IBOutlet weak var twoPoundsButton: UIButton!
    @IBOutlet weak var fivePoundsButton: UIButton!
    @IBOutlet weak var tenPoundsButton: UIButton!
    @IBOutlet weak var charityNameLabel: UILabel!
    
    weak var sellVC: SellViewController!
    var priceChosen: Int?
    var locationManager: CLLocationManager!
    var lastLocation: CLLocation?
    
    
    
    @IBAction func cancelButtonTouched(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButtonTouched(sender: AnyObject) {
        let auction = Auction()
        auction.photo = photoImageView.image
        auction.text = descriptionTextField.text
        auction.price = priceChosen!
        
//        Auction.userAuctions.append(auction)
//        let parent = parentViewController as! SellViewController
//        parent.backendConnector.postAuction(auction)
        auction.longitude = lastLocation?.coordinate.longitude
        auction.latitude = lastLocation?.coordinate.latitude
        
        
        sellVC.backendConnector.postAuction(auction)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func photoImageViewTouched(sender: AnyObject) {
//        poc = [[UIImagePickerController alloc] init];
//        [poc setTitle:@"Take a photo."];
//        [poc setDelegate:self];
//        [poc setSourceType:UIImagePickerControllerSourceTypeCamera];
//        poc.showsCameraControls = NO;
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            println("available")
        } else {
            println("unavailable")
        }
        
        imagePicker.title = "Take your item's photo"
        imagePicker.delegate = self
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func resetButtonColors() {
        self.onePoundButton.backgroundColor = UIColor.whiteColor()
        self.twoPoundsButton.backgroundColor = UIColor.whiteColor()
        self.fivePoundsButton.backgroundColor = UIColor.whiteColor()
        self.tenPoundsButton.backgroundColor = UIColor.whiteColor()
        
        self.onePoundButton.tintColor = UIView.defaultColor()
        self.twoPoundsButton.tintColor = UIView.defaultColor()
        self.fivePoundsButton.tintColor = UIView.defaultColor()
        self.tenPoundsButton.tintColor = UIView.defaultColor()
    }
    
    @IBAction func onePoundTouched(sender: UIButton) {
        self.priceLabel.text = "£1"
        self.resetButtonColors()
        sender.tintColor = UIColor.whiteColor()
        sender.backgroundColor = UIView.defaultColor()
        priceChosen = 1
    }
    
    @IBAction func twoPoundsTouched(sender: UIButton) {
        self.priceLabel.text = "£2"
        self.resetButtonColors()
        sender.tintColor = UIColor.whiteColor()
        sender.backgroundColor = UIView.defaultColor()
        priceChosen = 2
    }
    
    @IBAction func fivePoundsTouched(sender: UIButton) {
        self.priceLabel.text = "£5"
        self.resetButtonColors()
        sender.tintColor = UIColor.whiteColor()
        sender.backgroundColor = UIView.defaultColor()
        priceChosen = 5
    }
    
    @IBAction func tenPoundsTouched(sender: UIButton) {
        self.priceLabel.text = "£10"
        self.resetButtonColors()
        sender.tintColor = UIColor.whiteColor()
        sender.backgroundColor = UIView.defaultColor()
        priceChosen = 10
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let buttonsColor = UIView.defaultColor()
        self.onePoundButton.setBordersColor(buttonsColor)
        self.twoPoundsButton.setBordersColor(buttonsColor)
        self.fivePoundsButton.setBordersColor(buttonsColor)
        self.tenPoundsButton.setBordersColor(buttonsColor)
        
        let cornerRadius = self.onePoundButton.bounds.height / 2
        self.onePoundButton.layer.cornerRadius = cornerRadius
        self.onePoundButton.layer.cornerRadius = cornerRadius
        self.twoPoundsButton.layer.cornerRadius = cornerRadius
        self.fivePoundsButton.layer.cornerRadius = cornerRadius
        self.tenPoundsButton.layer.cornerRadius = cornerRadius
        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
//        locationManager.distanceFilter = kCLDistanceFilter.None
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {

        
//        let size = CGSizeApplyAffineTransform(image.size, CGAffineTransformMakeScale(0.5, 0.5))
        let aspect = image.size.height / image.size.width
        let width = 350.0 as CGFloat
        
        
        let size = CGSizeMake(width, width * aspect)
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.drawInRect(CGRect(origin: CGPointZero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.photoImageView.image = scaledImage
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
//    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
//        lastLocation = locations.first as? CLLocation
//    }
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        lastLocation = newLocation
    }
}