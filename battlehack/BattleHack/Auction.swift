//
//  Auction.swift
//  
//
//  Created by Alexander Juda on 26/04/15.
//
//

import Foundation
import MapKit

class Auction : NSObject, MKAnnotation {
    
    var id: Int!
    var photo: UIImage!
    var text: String!
    var price: Int!
    var starred: Bool!
    var longitude: Double!
    var latitude: Double!
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2DMake(self.latitude, self.longitude)
        }
    }
    
    var title: String! {
        get {
            return self.text
        }
    }
    
    func deserialize(jsonObject: [String : AnyObject]) {
//        if let
            let text: String        = jsonObject["description"] as! String
            let price: Int          = jsonObject["price"] as! Int
            let backendID: Int      = jsonObject["id"] as! Int
            let longitude: Double   = jsonObject["longitude"] as! Double
            let latitude: Double    = jsonObject["latitude"] as! Double //{
        
                let url = NSURL(string: "http://10.205.251.112:9000/photos/\(backendID)")
                
                self.photo = UIImage(data: NSData(contentsOfURL: url!)!)
                self.id = backendID
                self.text = text
                self.price = price
                self.starred = false
                self.longitude = longitude
                self.latitude = latitude
//        }
    }
    
    func serialize() -> [String : AnyObject] {
        var imageData = UIImagePNGRepresentation(photo).base64EncodedStringWithOptions(NSDataBase64EncodingOptions.allZeros)
        var jsonObject: [String: AnyObject] = [
            "photo": imageData,
            "text": text,
            "price": price,
            "longitude": longitude,
            "latitude":latitude
        ]
        return jsonObject
    }
    
    
//    static var globalAuctions: [Auction] {
//        get {
//            static var auctions: [Auction]?
//            if auctions == nil {
//                auctions = []
//            }
//            return auctions!
//        }
//    }
    static var userAuctions: [Auction] = []
    static var localAuctions: [Auction] = []
}
