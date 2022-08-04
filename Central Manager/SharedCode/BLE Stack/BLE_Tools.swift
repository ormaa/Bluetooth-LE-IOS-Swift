//
//  BLE_Tools.swift
//  
//
//  Created by Olivier Robin on 01/03/2017.
//  Copyright © 2017 fr.ormaa. All rights reserved.
//

import Foundation
import CoreBluetooth

extension BLECentralManager {
    
    
    // return bluetooth status
    //
    func getBlueToothStatus() -> Bool? {
        return blueToothEnabled
    }
    
    
    
    // read RSSI DB for a peripehral discovered
    //
    func getPeripheralRSSI(peripheralName: String) ->NSNumber? {
        if peripherals.count > 0 {
            for index in 0...peripherals.count - 1 {
                let name = getPeripheralName(number: index)
                if name == peripheralName {
                    //return peripherals[index].identifier.uuidString
                    let RSSI = rssiDB[index]
                    return RSSI
                }
            }
        }
        return nil
    }
    
    
    
    func isDeviceFound(uuidName: String) ->Bool {
        log("is devie found")

        if peripherals.count > 0 {
            log("devices :")
            for i in 0...peripherals.count - 1 {
                let n = getPeripheralUUID(number: i)
                log("device : \(n)")
                if n == uuidName {
                    return true
                }
            }
        } else {
            log("no BLE devices found")
        }
        
        return false
    }
    
    
//    
//    // Return peripheral UUID
//    //
//    func getPeripheralUUID(number: Int) -> String {
//        
//        let peripheral = peripherals[number]
//        let name = peripheral.identifier.uuidString
//        return name
//    }
    
    
    //REturn peripheral name
    func getShortPeripheralName(number: Int) -> String {
        
        let peripheral = peripherals[number]
        var name = peripheral.name //.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\t", with: "")
        if name == nil {
            name = peripheral.identifier.uuidString
        }
        
        return name!
    }

    
    //Return peripheral name
    //
    func getPeripheralUUID(number: Int) -> String {
        
        //name = name?.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\t", with: "")
        // if there is an advertisement with a local name, use it.
        let a = advertisementDatas[number]
        
        if a.array["kCBAdvDataServiceUUIDs"] != nil  {
            let uuid = a.array["kCBAdvDataServiceUUIDs"] as! NSArray
            
            let str = String(describing: uuid[0])
            return str
        } else {
            return "advertisement issue. got " + String(describing: a.array)
        }
        // return ""
    }
    
    //Return peripheral name
    //
    func getPeripheralName(number: Int) -> String {
        
        let peripheral = peripherals[number]
        var name = peripheral.name
        if name != nil {
            
            //name = name?.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\t", with: "")
            // if there is an advertisement with a local name, use it.
            let a = advertisementDatas[number]
            if a.array["kCBAdvDataLocalName"] != nil  {
                name = a.array["kCBAdvDataLocalName"] as! String?
            }
        }
        else {
            name = peripheral.identifier.uuidString
        }
        return name!
    }
    
    
    func getPeripheralIdentifier(peripheralName: String) ->String {
        if peripherals.count > 0 {
            for index in 0...peripherals.count - 1 {
                
                let name = getPeripheralName(number: index)
                if name == peripheralName {
                    return peripherals[index].identifier.uuidString
                }
            }
        }
        return ""
    }
    
    
    
    // return a peripheral state, in string, easily readable.
    func getState(_ state: CBPeripheralState) -> String {
        if state == .connected {
            return "connected"
        }
        if state == .connecting {
            return "connecting"
        }
        if state == .disconnected {
            return "disconnected"
        }
        if state == .disconnecting {
            return "disconnecting"
        }
        return ""
    }

}
