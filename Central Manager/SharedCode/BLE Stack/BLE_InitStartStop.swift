//
//  BLECentraManager+InitStartStop.swift
//  BlueToothCentral
//
//  Created by Olivier Robin on 07/11/2016.
//  Copyright © 2016 fr.ormaa. All rights reserved.
//


import Foundation
//import UIKit
import CoreBluetooth


// Apple documentation :
// https://developer.apple.com/library/content/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/CoreBluetoothBackgroundProcessingForIOSApps/PerformingTasksWhileYourAppIsInTheBackground.html


extension BLECentralManager {

    func log(_ object: Any?) {
        appDelegate?.singleton.logger.log(object)
    }
    
    
    // start discover of BLE peripherals
    //
    func initCentralManager(bleDelegate: BLEProtocol) {
        self.bleDelegate = bleDelegate

//        #if IOS
//        appDelegate =  UIApplication.shared.delegate as! AppDelegate?
//        #endif
//        #if MACOS
//        appDelegate =  UIApplication.shared.delegate as! AppDelegate?
//        #endif
        
        log("initCentralManager - Starting CentralManager")
        bleError = ""
        blueToothEnabled = nil
        
        // Delete all device, services, rssDB found previously
        peripherals.removeAll()
        rssiDB.removeAll()
        servicesDiscovered.removeAll()
        advertisementDatas.removeAll()
 
        // in case of centralManager was already started, stop scan, and free the object
        centralManager?.stopScan()
        centralManager = nil
        
        // pause the processor, 0.5 sec, before initalize it
        // is it needed ???
        usleep(500000)
        
        centralManager = CBCentralManager(delegate: self, queue: nil, options:[CBCentralManagerOptionRestoreIdentifierKey: "fr.ormaa.centralManager"])
    }

    
    
    // start to scan peripherals
    func startScan() {

        log("startScan peripheral")
        let BLEServiceUUID = CBUUID(string: "00001901-0000-1000-8000-00805F9B34FB")
        centralManager?.scanForPeripherals(withServices: [BLEServiceUUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
    }
    
    
    
    // Stop scan
    func stopScan() {
        centralManager?.stopScan()
    }
    
    

    

    // delegate
    // called after init centralManager
    //
    func centralManagerDidUpdateState(_ central: CBCentralManager){
        appDelegate?.singleton.logger.log("centralManagerDidUpdateState")
        
        if (central.state == CBManagerState.poweredOn){
            log("BlueTooth is powered ON")
            blueToothEnabled = true
        }else{
            log("BlueTooth is OFF or disconnected !!!")
            blueToothEnabled = false
        }
    }
    

    // Delegate
    // The app was killed by IOS, then BLE was disconnected. this is called when device is visible again
    //
    public func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        
        log("will restore connection")
        
        if let peripheralsObject = dict[CBCentralManagerRestoredStatePeripheralsKey] {
            let peripherals = peripheralsObject as! Array<CBPeripheral>
            if peripherals.count > 0 {
                log("Peripheral found")
                
                let peripheral = peripherals[0]
                peripheral.delegate = self
                self.peripherals.append(peripheral)
                self.rssiDB.append(NSNumber())
                self.advertisementDatas.append(oneAdvertisement( array: ["none": "none"]))

                if getState(peripheral.state) == "connected" {
                    log("connection to peripheral")
                    self.connect(peripheral: peripheral)
                }
            }
        }
    }
    
    
    
    // delegate
    //
    // 3°) peripheral discovered.
    //
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber){
        
        // if it is already added -> return
        if (peripherals.contains(peripheral)) {
            return
        }
        
        var name = peripheral.name
        if name == nil {
            name = peripheral.identifier.uuidString
        }
        
        log("-- Peripheral discovered")
        log("-- Peripheral name - status : " + Tools.toString(name) + " - " + getState(peripheral.state))
        log("-- Peripheral uuid: " + peripheral.identifier.uuidString)
        log("-- Peripheral adv : " + String(describing: advertisementData))
        
        // save first level of signal
        rssiDB.append( RSSI )
        // Add the peripheral to the list
        peripherals.append(peripheral)
        // save advertisement datas
        if advertisementData.count > 0 {
            log("-- Peripheral adverstisement")
            log(advertisementData)
            // can be : ["kCBAdvDataIsConnectable": 1, "kCBAdvDataTxPowerLevel": 8, "kCBAdvDataLocalName": PTCmajcoghaoncp]
            self.advertisementDatas.append(oneAdvertisement(array: advertisementData))
        }
        else {
            self.advertisementDatas.append(oneAdvertisement( array: ["none": "none"])) //key: "none", value: "none"))
        }
        
    }

    
    
}
