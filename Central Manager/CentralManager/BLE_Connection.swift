//
//  BLECentralManager+Connect.swift
//  BlueToothCentral
//
//  Created by Olivier Robin on 07/11/2016.
//  Copyright © 2016 fr.ormaa. All rights reserved.
//


import Foundation
import UIKit
import CoreBluetooth


extension BLECentralManager {

 
    
    // Connect to a peripheral, listed in the peripherals list
    //
    func connectToAsync(serviceUUID: String) {
        
        //centralManager?.stopScan()
        bleError = ""
        
        if peripherals.count > 0 {
            
            for i in 0...peripherals.count - 1 {
                let n = getPeripheralUUID(number: i)
                if n == serviceUUID {
                    connect(peripheral: peripherals[i])
                }
            }
        }
    }

    
    
    // Connect to a peripheral
    //
    func connect(peripheral: CBPeripheral?) {
        //stopBLEScan()
        
        if (peripheral != nil) {
            peripheralConnecting = peripheral
            peripheralConnected = nil
            let options = [CBConnectPeripheralOptionNotifyOnConnectionKey: true as AnyObject,
                           CBConnectPeripheralOptionNotifyOnDisconnectionKey: true as AnyObject,
                           CBConnectPeripheralOptionNotifyOnNotificationKey: true as AnyObject,
                           CBCentralManagerRestoredStatePeripheralsKey: true as AnyObject,
                           CBCentralManagerRestoredStateScanServicesKey : true as AnyObject]
            peripheral?.delegate = self
            centralManager?.connect(peripheral!, options: options)
        }
    }
    
    
    
    // disconnect from a connected peripheral
    //
    func disconnect() {
        log( "disconnect peripheral")
        if peripheralConnecting != nil {
            centralManager?.cancelPeripheralConnection(peripheralConnecting!)
        }
    }
    
    
    
    // delegate
    //
    // Connected to a peripheral
    //
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral){
        if peripheral.name != nil {
            log("didConnect event, peripheral: " + peripheral.name!)
        }
        else {
            log("didConnect event, peripheral identifier: " + peripheral.identifier.uuidString)
        }

        peripheralConnected = peripheral
        var name = "nil"
        if peripheral.name != nil {
            name = peripheral.name!
        }
        bleDelegate?.connected(message: name)
    }

    
    // delegate
    // Fail to connect
    //
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        if error != nil {
            bleError = ("Error didFailToConnect : \(error!.localizedDescription)")
            log(bleError)
            bleDelegate?.failConnected(message: error!.localizedDescription)
        }
        else {
            log("didFailToConnect")
            bleDelegate?.failConnected(message: "")
        }
        
    }
    
    
    
    // delegate
    //
    // disconnected form a peripheral
    //
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if error != nil {
            bleError = ("Error didDisconnectPeripheral : \(error!.localizedDescription)")
            log(bleError)
            bleDelegate?.disconnected(message: error!.localizedDescription)
        }
        else {
            log("didDisconnectPeripheral")
            bleDelegate?.disconnected(message: "")
        }
    }
    
    
    
    // delegate
    // Called when connection is lost, or done again
    //
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        log("peripheral service modified. May be connection is lost !")
        
        for s in invalidatedServices {
            log("service: " + s.uuid.uuidString)
        }
    }
    
    
    
    // delegate
    // name of the device update
    //
    func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
        log("peripheral name has change : " + peripheral.name!)
    }
    


    
}
