//
//  BraintreeController.swift
//  BattleHack
//
//  Created by Wojciech Kryscinski on 25/04/15.
//  Copyright (c) 2015 Alexander Juda. All rights reserved.
//

import Foundation

extension BackendConnector {
    
    func getToken() {
        if let
            tokenUrl: NSURL = NSURL(string: "/braintree/token", relativeToURL: serverUrl),
            userToken = BackendConnector.getUserToken() {
            let urlRequest = NSMutableURLRequest(URL: tokenUrl)
            urlRequest.HTTPMethod = "GET"
            
            let task = self.urlSession.dataTaskWithRequest(urlRequest) {
                (data, urlResponse, error) in
                var deserializationError: NSError?
                if let
                    responseJson = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &deserializationError) as? [String: String],
                    clientToken = responseJson["braintree_client_token"] {
                        self.braintree = Braintree(clientToken: clientToken)
                        println("Request done")
                }
            }
            task.resume()
        }
    }
    
    func postNonce(paymentMethodNonce: String) {
        var paramteres = ["payment_method_nonce": paymentMethodNonce]
        
        if let
            paymentUrl = NSURL(string: "/auctions", relativeToURL: serverUrl),
            userToken = BackendConnector.getUserToken() {
            let urlRequest = NSMutableURLRequest(URL: paymentUrl)
            urlRequest.HTTPMethod = "POST"
                
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
    
    // MARK: Helper functions
    func saveClientToken(clientToken: String) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(clientToken, forKey: "braintree.clientToken")
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
    }
    
    func getClientToken() -> String? {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let clientToken = userDefaults.valueForKeyPath("braintree.clientToken") as? String {
            return clientToken
        } else {
            return nil
        }
    }
}