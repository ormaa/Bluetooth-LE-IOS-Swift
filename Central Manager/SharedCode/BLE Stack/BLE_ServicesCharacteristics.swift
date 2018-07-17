//
//  BLECentralManager+ServicesCharacteristics.swift
//  BlueToothCentral
//
//  Created by Olivier Robin on 07/11/2016.
//  Copyright © 2016 fr.ormaa. All rights reserved.
//

import Foundation
import CoreBluetooth
//import UIKit
//import UserNotifications



extension BLECentralManager {
    
    
    // allow the discover services and characteristics of the peripharal already connected
    //
    func discoverServicesAndCharac() {
        bleError = ""
        servicesDiscovered.removeAll()
        peripheralConnected?.discoverServices( nil )
    }


    
    func setNotify(characteristicUUID: String) {

        peripheralConnected?.services?.forEach({ (oneService) in
            oneService.characteristics?.forEach({ (oneCharacteristic) in
                if oneCharacteristic.uuid == CBUUID(string: characteristicUUID) {
                    peripheralConnected?.setNotifyValue(true, for: oneCharacteristic)
                    log("request notification done")
                }
            })
        })
        
    }
    
    
    
    
    // delegate
    // Discovered service of the peripheral
    //
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        if error != nil {
            bleError = ("Error discovering services: \(error!.localizedDescription)")
            log(bleError)
        }
        else {
            log("didDiscoverServices services")
        }
        
        peripheral.services?.forEach({ (oneService) in
            log("------ Service : " + Tools.toString( oneService.uuid.uuidString ))
            // discopver the characteristics for that service
            peripheral.discoverCharacteristics(nil, for: oneService)
        })
        
    }
    
    
    
    // delegate
    // discovered characteristics for a service
    //
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?){
        if error != nil {
            bleError = ("Error service characteristics: \(error!.localizedDescription)")
            log(bleError)
        }
        else {
            log("didDiscoverCharacteristicsFor")
        }
        
        if !servicesDiscovered.contains(service) {
            servicesDiscovered.append(service)
        }

        // enumerate all the characteristics of this service
        service.characteristics?.forEach({ (oneCharacteristic) in
            log("-- Characteristic : " + Tools.toString( oneCharacteristic.uuid.uuidString ))
        })
        
        isServicesDiscovered = true
        
    }
    
    
    
    // delegate
    // tell if notification when we request a notification for a charac.
    //
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            bleError = ("Error didUpdateNotificationStateFor : " + error!.localizedDescription)
        }
        else {
            log("didUpdateNotificationStateFor characteristic : " + characteristic.uuid.uuidString )
        }
    }
    

    

    
}
