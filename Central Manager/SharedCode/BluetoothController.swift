//
//  BluetoothController.swift
//  CentralManager
//
//  Created by Olivier Robin on 04/03/2017.
//  Copyright © 2017 fr.ormaa. All rights reserved.
//

import Foundation
//import UIKit


class BluetoothController: BLEProtocol {


    
    var appDelegate:AppDelegate? = nil
    
    
    var isConnected = false
    var isConnecting = false
    var disconnectEvent = false

    var bleError = ""
    
    // bluetooth Stack
    var ble = BLECentralManager()
    
    // used to measure time and manage timeout
    var start = Date()
    var end = Date()
    var time = TimeInterval()
    
    var viewControllerDelegate: BLEProtocol? = nil
    
    
    func log(_ object: Any?) {
        appDelegate?.singleton.logger.log(object)
    }
    
    
    
    func restoreCentralManager(viewControllerDelegate: BLEProtocol, centralName: String) {
        //appDelegate =  UIApplication.shared.delegate as! AppDelegate?

        self.viewControllerDelegate = viewControllerDelegate
        
        // Start the central manager. it will fire the willRestore Event
        self.ble.initCentralManager(bleDelegate: self)
    }
    
    
    
    //--------------------------------------------------------------------------------------------------------------
    
    // start  central manager
    // do it in a separate thread than UI !
    //
    func startCentralManager(viewControllerDelegate: BLEProtocol) -> Bool {
        
        //appDelegate =  UIApplication.shared.delegate as! AppDelegate?
        self.viewControllerDelegate = viewControllerDelegate
        
        //let controller = UIApplication.shared.keyWindow?.rootViewController

        isConnected = false
        isConnecting = false
        disconnectEvent = false
        
        //mainMenuDelegate?.displayText(message: "Recherche de votre device")
        log("----------------------------------------------------------------------")
        log("startCentralManager")
        
        // start the central manager
        self.ble.appDelegate = self.appDelegate
        self.ble.initCentralManager(bleDelegate: self )

        // centralmanager will fire an event : bluetooth on, or off
        let b = self.waitBluetoothStatus()
        if !b {
            return false
        }
        
//        // start to scan for peripherals
//        self.ble.startScan()
    
        log("startCentralManager completed")
        return true
    }

    func stopCentralManager() {
        self.ble.stop()
    }
    
    // wait for bluetooth status is true or false
    //
    func waitBluetoothStatus() -> Bool {
        
        repeat {
            usleep(500000)
        }
        while ble.getBlueToothStatus() == nil
        
        return ble.getBlueToothStatus()!
    }
    

    
    // search in peripherals foudn is there is one or more "PTC..." device
    // Search for 6 second, at least, to be sure all device are visible durting the scan
    func searchDevice(uuidName: String) -> Bool {
        
        log("----------------------------------------------------------------------")
        log("Search for Device: " + uuidName)

        // start to scan for peripherals
        self.ble.startScan(uid: uuidName)

        self.start = Date()
        repeat {
            usleep(500000)
            self.end = Date()
            self.time = self.end.timeIntervalSince(self.start) // * 1000
        }
        while self.time.second < 1 || (self.time.second >= 1 && !ble.isDeviceFound(uuidName: uuidName) && self.time.second < 20 )
        
        if self.time.second >= 20 {
            log("searchDevice timeout")
            return false
        }
        return true
    }
    
    

    
    // discover service and charac. with time out.
    func discoverServices() -> Bool {
        log("discovering services and Charac.")
        
        start = Date()
        self.ble.discoverServicesAndCharac()
        
        repeat {
            usleep(500000) // Sleep for 0.5s
        }
        while !self.ble.isServicesDiscovered && self.ble.bleError == ""
        //completion(self.bleError)        }

        if ble.bleError == "" {
            return true
        }
        else {
            return false
        }
    }

    
    
    // connect to a device, with a time out
    //
    func connectToDevice(uuid: String) -> Bool {
        isConnected = false
        
        log("----------------------------------------------------------------------")
        log("connecting to peripheral ...")
        start = Date()
        self.ble.connectToAsync(serviceUUID: uuid)
        
        repeat {
            usleep(300000) // Sleep for 0.3s
            end = Date()
            time = end.timeIntervalSince(start)// * 1000
        }
            while !isConnected && time.second < 60
        
        bleError = ble.bleError
        if bleError == "" {
            bleError = "Timeout"
        }
        if !isConnected {
            log("connection failed.")
            //ble.disconnect()
            return false
        }
        else {
            log("connection to peripheral is done")
            return true
        }
    }
    

    func read(uuid: String) {
        ble.readValue(characUUID: uuid)
    }
    
    func write(uuid: String, message: String) {
        ble.writeValue(characUUID: uuid, message: message)
    }
    
    func writeAsync(uuid: String, message: String) {
        ble.writeValueAsync(characUUID: uuid, value: message.data(using: .utf16)!)
    }

    func requestNotify(uuid: String) {
        ble.setNotify(characteristicUUID: uuid)
    }
    
    
    
    // protocol events
    
    
    // called by bluetooth stack
    //
    func valueRead(message: String) {
        log("valueRead : " + message)
        
        viewControllerDelegate?.valueRead(message: message)
    }

    func valueWrite(message: String) {
        log("valueRead : " + message)
        
        viewControllerDelegate?.valueWrite(message: message)
    }
    
    
    
    
    // disconnected : ble is too far away, or sitched off
    func disconnected(message: String) {
        log("disconnect event")

        if let delegate = self.appDelegate {
            if !delegate.singleton.appRestored {
                if !isConnected {
                    // if connection fail, this event can be fired even if we are not already connected
                    log("connection failed. is not connected")
                    return
                }
            }

            isConnected = false
            disconnectEvent = true  // allow to know that we are not connected, and there is an event.

            // Will display some message
            viewControllerDelegate?.disconnected(message: message)
        } else {
            log("delegate no initalized !")
        }
    }
    
    
    
    // connection to ble failed
    func failConnected(message: String) {
        log("FailConnect event")
        
        isConnected = false
        
        // Will display some message
        viewControllerDelegate?.failConnected(message: message)
    }
    
    
    
    func connected(message: String) {
        log("device connected event : " + message)
        isConnected = true
        
        // Will display some message
        viewControllerDelegate?.connected(message: message)
    }



    
}


