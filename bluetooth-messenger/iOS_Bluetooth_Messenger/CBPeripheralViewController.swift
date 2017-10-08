//
//  CBPeripheralViewController.swift
//  iOS_Bluetooth_Messenger
//
//  Created by Wojtek on 8/25/14.
//  Copyright (c) 2014 Wojtek. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

class CBPeripheralViewController: UIViewController, CBPeripheralManagerDelegate, UITextViewDelegate {
    @IBOutlet var textView: UITextView!
    
    var peripheralManager: CBPeripheralManager!
    var transferCharacteristic: CBMutableCharacteristic!
    var dataToSend: NSData!
    var sendDataIndex: NSInteger!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        self.peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [CBUUID.UUIDWithString(transferServiceUUID)]])
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.peripheralManager.stopAdvertising()
        super.viewWillDisappear(animated)
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        if (peripheral.state != CBPeripheralManagerState.PoweredOn) {
            return
        } else if (peripheral.state == CBPeripheralManagerState.PoweredOn) {
            self.transferCharacteristic = CBMutableCharacteristic(type: CBUUID.UUIDWithString(transferCharacteristicUUID), properties: CBCharacteristicProperties.Notify, value: nil, permissions: CBAttributePermissions.Readable)
            var transferService = CBMutableService(type: CBUUID.UUIDWithString(transferServiceUUID), primary: true)
            transferService.characteristics = [self.transferCharacteristic]
            self.peripheralManager.addService(transferService)
        }
    }
    
    func peripheralManager(peripheral: CBPeripheralManager!, central: CBCentral!, didSubscribeToCharacteristic characteristic: CBCharacteristic!) {
        self.dataToSend = textView.text.dataUsingEncoding(NSUTF8StringEncoding)
        self.sendDataIndex = 0
        self.sendData()
    }
    
    func peripheralManagerIsReadyToUpdateSubscribers(peripheral: CBPeripheralManager!) {
        self.sendData()
    }
    
    func sendData() {
        var sendingEOM: Bool = false
        
        if (sendingEOM) {
            var didSend: Bool = self.peripheralManager.updateValue("EOM".dataUsingEncoding(NSUTF8StringEncoding), forCharacteristic: self.transferCharacteristic, onSubscribedCentrals: nil)
                                NSLog("Sent: EOM")
            
            if (didSend) {
                sendingEOM = false
            }
            return
        }
        
        if (self.sendDataIndex >= self.dataToSend.length) {
            return
        }
        
        var didSend: Bool = true
        while (didSend) {
            var amountToSend: NSInteger = self.dataToSend.length - self.sendDataIndex
            
            if (amountToSend > notifyMTU) {
                amountToSend = notifyMTU
            }
            
            var chunk: NSData = NSData(bytes: self.dataToSend.bytes + self.sendDataIndex, length: amountToSend)
            didSend = self.peripheralManager.updateValue(chunk, forCharacteristic: self.transferCharacteristic, onSubscribedCentrals: nil)
            NSLog("DidSend: \(didSend)")
            
            if (!didSend) {
                NSLog("Something went wrong - returning!")
                return
            }
            
            var stringFromData: NSString = NSString(data: chunk, encoding: NSUTF8StringEncoding)
            self.sendDataIndex = amountToSend + self.sendDataIndex
            NSLog("Sent: \(stringFromData), Bytes: \(self.sendDataIndex), Total: \(self.dataToSend.length)")
            if (self.sendDataIndex >= self.dataToSend.length) {
                NSLog("Finishing broadcast")
                sendingEOM = true
                var eomSent = self.peripheralManager.updateValue("EOM".dataUsingEncoding(NSUTF8StringEncoding), forCharacteristic: self.transferCharacteristic, onSubscribedCentrals: nil)
                NSLog("EOM: \(eomSent)")
                if (eomSent) {
                    sendingEOM = false
                    NSLog("Sent: EOM")
                }
                
                return
            }
        }
       
    }
    
    
    
    
}