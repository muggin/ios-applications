//
//  BackendConnector.swift
//  BattleHack
//
//  Created by Wojciech Kryscinski on 25/04/15.
//  Copyright (c) 2015 Alexander Juda. All rights reserved.
//

import Foundation

class BackendConnector {
    let serverUrl: NSURL!
    let urlSession: NSURLSession!
    var braintree: Braintree!
    var delegate: BackendConnectorDelegate!
    
    init(serverAddress: String) {
        self.serverUrl = NSURL(string: serverAddress)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.urlSession = NSURLSession(configuration: config)
    }
    
    // MARK: Main functionality
    func postUser(loginCredentials: LoginCredentials) {
        if let usersUrl = NSURL(string: "/users", relativeToURL: serverUrl) {
            let urlRequest = NSMutableURLRequest(URL: usersUrl)
            urlRequest.HTTPMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            var requestError: NSError?
            urlRequest.HTTPBody = NSJSONSerialization.dataWithJSONObject(loginCredentials.serialize(), options: nil, error: &requestError)

            let task = self.urlSession.dataTaskWithRequest(urlRequest) {
                (data, urlResponse, error) in
                if (error == nil) {
                    var deserializationError: NSError?
                    var token = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &deserializationError) as? [String: AnyObject]
                    if (error == nil) {
                        if let userToken = token?["access_token"] as? String {
                            println(userToken)
                            BackendConnector.saveUserToken(userToken)
                            self.getToken()
                            println("Access token stored")
                            
                            self.delegate.didPostUser!()
                        }
                    } else {
                        println("Error parsing user token")
                    }
                } else {
                    println("Error registering user")
                }
            }
            task.resume()
        }
    }
    
    func getLocalAuctions() {
        if let
            auctionsUrl = NSURL(string: "/auctions/local", relativeToURL: serverUrl),
            userToken = BackendConnector.getUserToken() {
            let urlRequest = NSMutableURLRequest(URL: auctionsUrl)
        
            urlRequest.HTTPMethod = "GET"
            urlRequest.addValue(userToken, forHTTPHeaderField: "Authorization")
            
            var requestError: NSError?
            let task = self.urlSession.dataTaskWithRequest(urlRequest) {
                (data, urlResponse, error) in
                if (error == nil) {
                    var deserializationError: NSError?
                    if let auctionsJSON = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &deserializationError) as? [[String: AnyObject]] {
                        
                        var auctions: [Auction]? = []
                        for JSON in auctionsJSON {
                            let auction = Auction()
                            auction.deserialize(JSON)
                            auctions?.append(auction)
                        }
                        
                        self.delegate.didFetchLocalAuctions!(auctions)
                    }
                } else {
                    println("Error getting auctions")
                }
            }
            task.resume()
        } else {
            println("Error getting local auctions")
        }
    }
    
    func getUserAuctions() {
        if let
            auctionsUrl = NSURL(string: "/auctions/my", relativeToURL: serverUrl),
            userToken = BackendConnector.getUserToken() {
                let urlRequest = NSMutableURLRequest(URL: auctionsUrl)
                
                urlRequest.HTTPMethod = "GET"
                urlRequest.addValue(userToken, forHTTPHeaderField: "Authorization")
                
                var requestError: NSError?
                let task = self.urlSession.dataTaskWithRequest(urlRequest) {
                    (data, urlResponse, error) in
                    if (error == nil) {
                        var deserializationError: NSError?
                        if let auctionsJSON = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &deserializationError) as? [[String: AnyObject]] {
                            
                            var auctions: [Auction]? = []
                            for JSON in auctionsJSON {
                                let auction = Auction()
                                auction.deserialize(JSON)
                                auctions?.append(auction)
                            }
                            
                            self.delegate.didFetchUserAuctions!(auctions)
                        }
                    } else {
                        println("Error getting auctions")
                    }
                }
            task.resume()
        } else {
            println("Error getting user auctions")
        }
    }
    
    func postAuction(newAuction: Auction) {
        if let
            auctionsUrl = NSURL(string: "/auctions", relativeToURL: serverUrl),
            userToken = BackendConnector.getUserToken() {
                let urlRequest = NSMutableURLRequest(URL: auctionsUrl)
                
                urlRequest.HTTPMethod = "POST"
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.addValue(userToken, forHTTPHeaderField: "Authorization")
            
                var requestError: NSError?
                urlRequest.HTTPBody = NSJSONSerialization.dataWithJSONObject(newAuction.serialize(), options: nil, error: &requestError)
                let task = self.urlSession.dataTaskWithRequest(urlRequest) {
                    (data, urlResponse, error) in
                    if (error != nil) {
                        println(error.description)
                    }
                    println("Sent")
                }
                task.resume()
        } else {
            println("Error posting auction")
        }
    }

    func getToken() {
        if let
            tokenUrl: NSURL = NSURL(string: "/braintree/token", relativeToURL: serverUrl),
            userToken = BackendConnector.getUserToken() {
                let urlRequest = NSMutableURLRequest(URL: tokenUrl)
                urlRequest.HTTPMethod = "GET"
                urlRequest.addValue(userToken, forHTTPHeaderField: "Authorization")
                
                let task = self.urlSession.dataTaskWithRequest(urlRequest) {
                    (data, urlResponse, error) in
                    var deserializationError: NSError?
                    if let
                        responseJson = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &deserializationError) as? [String: String],
                        clientToken = responseJson["braintree_client_token"] {
                            self.saveClientToken(clientToken)
                            println(clientToken)
                            println("Request done")
                    }
                }
                task.resume()
        }
    }
    
    func postNonce(auctionId: Int, paymentMethodNonce: String) {
        var paramteres = ["nonce": paymentMethodNonce]
        
        if let
            paymentUrl = NSURL(string: "/auctions/\(auctionId)/donate", relativeToURL: serverUrl),
            userToken = BackendConnector.getUserToken() {
                let urlRequest = NSMutableURLRequest(URL: paymentUrl)
                urlRequest.HTTPMethod = "POST"
                urlRequest.addValue(userToken, forHTTPHeaderField: "Authorization")
                
                var serializationError: NSError?
                urlRequest.HTTPBody = NSJSONSerialization.dataWithJSONObject(paramteres, options: nil, error: &serializationError)
                
                let task = self.urlSession.dataTaskWithRequest(urlRequest) {
                    (data, urlResponse, error) in
                    
                    // TODO Handle response
                    println("Request done")
                }
                task.resume()
        }
    }
    
    // MARK: Helper methods
    static func saveUserToken(userToken: String) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(userToken, forKey: "authorization.userToken")
        userDefaults.synchronize()
    }
    
    static func getUserToken() -> String? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let userToken = userDefaults.valueForKey("authorization.userToken") as? String {
            return userToken
        } else {
            println("Empty")
            return nil
        }
    }
    
    func saveClientToken(clientToken: String) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(clientToken, forKey: "braintree.clientToken")
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
    }
    
    func getClientToken() -> String? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let clientToken = userDefaults.valueForKey("braintree.clientToken") as? String {
            println("clientToken found.")
            return clientToken
        } else {
            println("clientToken nil")
            return nil
        }
    }

}