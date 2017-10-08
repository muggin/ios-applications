//
//  MessageTest.swift
//  Angelhack
//
//  Created by Wojciech Kryscinski on 23/05/15.
//  Copyright (c) 2015 Alexander Juda. All rights reserved.
//

import UIKit
import XCTest

class MessageTest: XCTestCase {
    var bodyDictionary: [String: String]!
    var headerDictionary: [String: String]!

    override func setUp() {
        super.setUp()
        
        self.bodyDictionary = [:]
        self.headerDictionary = [:]
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testMessageBodySerialize() {
        var messageBody: Message.Body = Message.Body()
        messageBody.message = "Test message!"
        messageBody.signature = "Test signature!"
        var messsageDictionary: [String: String] = ["message":"Test message!", "signature":"Test signature"]
        println(messageBody.dictionarialize())
        XCTAssert(true, "Pass")
    }

    func testMessageBodyDeserialize() {
        // This is an examp
        XCTAssert(true, "Pass")
    }
    
    func testMessageHeaderSerialize() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testMessageHeaderDeserialize() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testMessageSerialize() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testMessageDeserialize() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
