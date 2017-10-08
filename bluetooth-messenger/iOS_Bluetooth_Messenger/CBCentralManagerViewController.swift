//
//  CBCentralManagerViewController.swift
//  iOS_Bluetooth_Messenger
//
//  Created by Wojtek on 8/25/14.
//  Copyright (c) 2014 Wojtek. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

class CBCentralManagerViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    @IBOutlet var textView: UITextView!
    
    var centralManager: CBCentralManager!
    var discoveredPeripheral: CBPeripheral!
    var data: NSMutableData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
        self.data = NSMutableData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.centralManager.stopScan()
        NSLog("Scanning stopped")
        super.viewWillDisappear(animated)
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        if (central.state != CBCentralManagerState.PoweredOn) {
            UIAlertView(title: "Warning!", message: "Bluetooth module is not on", delegate: nil, cancelButtonTitle: "OK")
        } else if (central.state == CBCentralManagerState.PoweredOn) {
            self.centralManager.scanForPeripheralsWithServices([CBUUID.UUIDWithString(transferServiceUUID)], options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
            NSLog("Scanning for peripherals")
        }
    }
    
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        NSLog("Discovered \(peripheral.name) at \(RSSI)")
        
        if (self.discoveredPeripheral != peripheral) {
            self.discoveredPeripheral = peripheral
            
            NSLog("Connecting to peripheral \(peripheral)")
            self.centralManager.connectPeripheral(peripheral, options: nil)
        }
    }
    
    func centralManager(central: CBCentralManager!, didFailToConnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        NSLog("Failed to connect")
        self.cleanup()
    }
    
    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
        NSLog("Connected")
        self.centralManager.stopScan()
        NSLog("Scanning stopped")
        
        self.data.length = 0
        peripheral.delegate = self
        peripheral.discoverServices([CBUUID.UUIDWithString(transferServiceUUID)])
    }
    
    func centralManager(central: CBCentralManager!, didDisconnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        self.discoveredPeripheral = nil
        self.centralManager.scanForPeripheralsWithServices([CBUUID.UUIDWithString(transferServiceUUID)], options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
    }
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        if (error != nil) {
            self.cleanup()
            return
        }
        
        for service in peripheral.services as [CBService] {
            peripheral.discoverCharacteristics([CBUUID.UUIDWithString(transferCharacteristicUUID)], forService: service)
        }
    }
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
        if (error != nil) {
            self.cleanup()
            return
        }
        
        for characteristic in service.characteristics as [CBCharacteristic] {
            if (characteristic.UUID.isEqual(CBUUID.UUIDWithString(transferCharacteristicUUID))) {
                peripheral.setNotifyValue(true, forCharacteristic: characteristic)
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        if (error != nil) {
            NSLog("Error")
            return
        }
        
        var stringFromData = NSString(data: characteristic.value, encoding: NSUTF8StringEncoding)
        NSLog("Recieved: \(stringFromData)")
        if (stringFromData.isEqualToString("EOM")) {
            self.textView.text = NSString(data: self.data, encoding: NSUTF8StringEncoding)
            peripheral.setNotifyValue(false, forCharacteristic: characteristic)
            self.centralManager.cancelPeripheralConnection(peripheral)
        }
        
        data.appendData(characteristic.value)
    }
    
    func peripheral(peripheral: CBPeripheral!, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        if (!characteristic.UUID.isEqual(CBUUID.UUIDWithString(transferCharacteristicUUID))) {
            return
        }
        
        if (characteristic.isNotifying) {
            NSLog("Notificiation began on \(characteristic)")
        } else {
            centralManager.cancelPeripheralConnection(peripheral)
        }
    }
    
    func cleanup() {
        if (self.discoveredPeripheral.services != nil) {
            for service in self.discoveredPeripheral.services as [CBService] {
                if (service.characteristics != nil) {
                    for characteristic in service.characteristics as [CBCharacteristic] {
                        if (characteristic.UUID.isEqual(CBUUID.UUIDWithString((transferCharacteristicUUID)))) {
                            if characteristic.isNotifying {
                                self.discoveredPeripheral.setNotifyValue(false, forCharacteristic: characteristic)
                                return
                            }
                        }
                    }
                }
            }
        }
        
        self.centralManager.cancelPeripheralConnection(self.discoveredPeripheral)
    }
    
}