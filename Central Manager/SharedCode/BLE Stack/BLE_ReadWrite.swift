//
//  BLE_ReadWrite.swift
//  BlueToothCentral
//
//  Created by Olivier Robin on 07/11/2016.
//  Copyright © 2016 fr.ormaa. All rights reserved.
//

import Foundation
//import UIKit
import CoreBluetooth



extension BLECentralManager {


    
    // read signal RSSI DB from peripheral
    //
    func readSignal(completion:@escaping (_ value: String, _ error: String) -> Void) {
        
        bleError = ""
        rssiDBConnected = nil
        
        // read battery level of peripheral
        peripheralConnected?.readRSSI()
        
        DispatchQueue.global(qos: .background).async {

            repeat {
                usleep(200000) // Sleep for 0.1s
            }
            while self.rssiDBConnected == nil && self.bleError == ""
            
            let str = Tools.toString(self.rssiDBConnected?.stringValue)
            completion(str, self.bleError)
        }

    }
    
    

    
    
    // read value from peripheral
    //
    func readValue(characUUID: String) {
        
        log("readValueAsync request : " + characUUID)
        bleError = ""
        valueReadBytes = []
        
        // read battery level of peripheral
        peripheralConnected?.services?.forEach({ (oneService) in
            oneService.characteristics?.forEach({ (oneCharacteristic) in
                if oneCharacteristic.uuid == CBUUID(string: characUUID) {
                    peripheralConnected?.readValue(for: oneCharacteristic)
                    log("read request sent")
                }
            })
        })
    }
    

    
    // Write a value to peripheral
    //
    func writeValue(characUUID: String, message: String) {
        
        log("writeValue request : " + characUUID)
        bleError = ""
        valueWritten = false
        
        peripheralConnected?.services?.forEach({ (oneService) in
            oneService.characteristics?.forEach({ (oneCharacteristic) in
                
                if oneCharacteristic.uuid == CBUUID(string: characUUID) {

                    let data: Data = message.data(using: String.Encoding.utf16)!
                    peripheralConnected?.writeValue(data, for: oneCharacteristic, type: CBCharacteristicWriteType.withResponse)
                    log("write request sent")
                }
            })
        })

    }

    
    
    
    // Write a value to peripheral
    //
    func writeValueAsync(characUUID: String, value: Data) {
        log("writeValue async request : " + characUUID )
        bleError = ""
        valueWritten = false
        
        peripheralConnected?.services?.forEach({ (oneService) in
            oneService.characteristics?.forEach({ (oneCharacteristic) in
                
                if oneCharacteristic.uuid == CBUUID(string: characUUID) {
                    //appController.log("sending value to remote peripheral")
                    peripheralConnected?.writeValue(value, for: oneCharacteristic, type: CBCharacteristicWriteType.withResponse)
                }
            })
        })
    
        usleep(10000) // Sleep for 0.01 sec
    }


    
    
    // delegate
    // data read from remote peripheral, or error
    //
    func peripheral(_ peripheral: CBPeripheral,  didUpdateValueFor characteristic: CBCharacteristic, error: Error?){
        
        if error != nil {
            bleError = ("Error didUpdateValueFor : " + error!.localizedDescription)
        }
        else {

            let array = [UInt8](characteristic.value!)
            var str = ""
            for b in array {
                str += String(describing: b)
            }
            
            str = String.init(data: characteristic.value!, encoding: .utf16)!
            
            log("didUpdateValueFor characteristic : " + characteristic.uuid.uuidString  + " -- " + str)
            
            // Save the value
            valueReadBytes = array
            
            bleDelegate?.valueRead(message: str)
        }
    }
    
    
    
    // delegate
    // data written to peripheral, with response from peripheral (ok, or error)
    //
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        
        if error != nil {
            bleError = ("Error didWriteValueFor : " + error!.localizedDescription)
        }
        else {
            //appController.log("didWriteValueFor" )
            valueWritten = true
        }
    }
    
    
    
    // delegate
    // RSSI was read : signal power
    //
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        
        if error != nil {
            log(("Error didReadRSSI : \(error!.localizedDescription)"))
        }
        else {
            log("didReadRSSI: " + Tools.toString(RSSI.stringValue))
        }
        
        rssiDBConnected = RSSI
        let index = peripherals.index(of: peripheral)
        if index != nil {
            rssiDB[index!] = RSSI
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
     

    
    
}
