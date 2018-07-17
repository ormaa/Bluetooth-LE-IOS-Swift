//
//  BLECentralManager.swift
//  BlueToothCentral
//
//  Created by Olivier Robin on 30/10/2016.
//  Copyright © 2016 fr.ormaa. All rights reserved.
//

import Foundation
import CoreBluetooth
//import UIKit
//import UserNotifications


// Doc apple
// https://developer.apple.com/library/content/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/PerformingCommonCentralRoleTasks/PerformingCommonCentralRoleTasks.html#//apple_ref/doc/uid/TP40013257-CH3-SW1




// BlueTooth do not work if it not instanciated, called, managed, from a uiview controller, linked to a .xib, or storyboard
//
class BLECentralManager : NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    
    var appDelegate:AppDelegate? = nil

    var centralManager: CBCentralManager? = nil
    
    // peripheral we are looking for...
    var peripheralConnecting: CBPeripheral? = nil
    var peripheralConnected: CBPeripheral? = nil
    var rssiDBConnected:NSNumber? = nil
    
    var peripherals: [CBPeripheral] = []
    var servicesDiscovered: [CBService] = []
    var rssiDB:[NSNumber] = []
    var advertisementDatas: [oneAdvertisement] = []
    
    var isServicesDiscovered = false
    var blueToothEnabled: Bool? = nil
    
    var bleError = ""
 
    var valueWritten = false
    var valueReadBytes: [UInt8] = []

    var bleDelegate: BLEProtocol?
    
}



