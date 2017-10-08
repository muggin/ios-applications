//
//  BuyMapViewController.swift
//  BattleHack
//
//  Created by Alexander Juda on 25/04/15.
//  Copyright (c) 2015 Alexander Juda. All rights reserved.
//

import Foundation
import MapKit

class BuyMapViewController : UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imageView: UIImageView!
    
    var locationManager: CLLocationManager!
    
    var userAuctions: [Auction]!
    var localAuctions: [Auction]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
//        auctions = Seeder.generateAuctions()
//        userAuctions = Auction.userAuctions
        localAuctions = Auction.localAuctions
        
        setupAnnotations()
    }
    
    func setupAnnotations() {
        for auction in localAuctions! {
//            let pointAnnotation = MKPointAnnotation()
//            pointAnnotation.coordinate = CLLocationCoordinate2DMake(auction.latitude, auction.longitude)
//            pointAnnotation.title = auction.text
            
            mapView.addAnnotation(auction)
        }
    }
//    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
//        let annotationView = MKAnnotationView()
//        annotationView.image = UIImage(named:"Hearts Filled-100")
        println("\(annotation.coordinate.longitude) \(annotation.coordinate.latitude)")
        
        if annotation.isKindOfClass(MKPointAnnotation) {
            let identifier = "auctionAnnotation"
            var pinAnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            
            if (pinAnnotationView != nil) {
                pinAnnotationView.annotation = annotation
            }
            else {
                pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                pinAnnotationView.enabled = true
                pinAnnotationView.canShowCallout = true
            }
            
            return pinAnnotationView
        } else {
            return nil
        }
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        if view.annotation.isKindOfClass(Auction) {
            let auction = view.annotation as! Auction
            imageView.image = auction.photo
        }
    }
    
//    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
//        let region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800)
//        mapView.region = region
//    }
    
    
//    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        println(status)
//    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        println(locations)
    }
}