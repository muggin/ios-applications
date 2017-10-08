//
//  AuctionDetailsViewController.swift
//  BattleHack
//
//  Created by Alexander Juda on 26/04/15.
//  Copyright (c) 2015 Alexander Juda. All rights reserved.
//

import Foundation
import MapKit

class AuctionDetailsViewController : UIViewController, BTDropInViewControllerDelegate {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var charityNameLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var backendConnector = BackendConnector(serverAddress: "http://10.205.251.112:9000")
    var auction: Auction!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoImageView.image = auction.photo
        descriptionLabel.text = auction.text
        charityNameLabel.text = "Charity"
        
    }
    
    @IBAction func buyButtonTouched(sender: AnyObject) {
        var clientToken = getClientToken()
        println(clientToken)
        var bt = Braintree(clientToken: clientToken)
        
        var dropInViewController: BTDropInViewController = bt.dropInViewControllerWithDelegate(self)
        dropInViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: Selector("userDidCancel"))
        var navigationController: UINavigationController = UINavigationController(rootViewController: dropInViewController)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func getClientToken() -> String? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let clientToken = userDefaults.valueForKey("braintree.clientToken") as? String {
            return clientToken
        } else {
            return nil
        }
    }
    
    func userDidCancel() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func dropInViewControllerDidCancel(viewController: BTDropInViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func dropInViewControllerWillComplete(viewController: BTDropInViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func dropInViewController(viewController: BTDropInViewController!, didSucceedWithPaymentMethod paymentMethod: BTPaymentMethod!) {        
        var params: [String: AnyObject] = [
            "nonce": paymentMethod.nonce
        ]
        backendConnector.postNonce(3, paymentMethodNonce: paymentMethod.nonce)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}