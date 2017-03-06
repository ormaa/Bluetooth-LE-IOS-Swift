//
//  BLECentralManager.swift
//  BlueToothCentral
//
//  Created by Olivier Robin on 30/10/2016.
//  Copyright © 2016 fr.ormaa. All rights reserved.
//

import Foundation
import CoreBluetooth
import UIKit
import UserNotifications

import AELog
import AEConsole

// UUID of this peripheral service, and characteristics
// can be generated using "uuidgen" under osx console

let BLEGenericService = "1B0986D4-2B1C-4DF7-A998-D86DFD794AE6" //"A180"
let BLERead  = "2AC6A7BF-2C60-42D0-8013-AECEF2A124C0" //"A181"
let BLEWrite = "9B89E762-226A-4BBB-A381-A4B8CC6E1105"


protocol BLEPeripheralProtocol {
    func BlueToothStatus(peripheral: CBPeripheralManager)
}


// BlueTooth do not work if it not instanciated, called, managed, from a uiview controller, linked to a .xib, or storyboard
//
class BLEPeripheralManager : NSObject, CBPeripheralManagerDelegate {
    
    var localPeripheralManager: CBPeripheralManager! = nil
    var localService:CBService? = nil
    var localPeripheral:CBPeripheral? = nil
    
    // try to save the service created, inorder to be sure it is not emoved from memory
    // TODO check if useful
    var createdService:CBService? = nil
    
    var peripheralDiscoverableName = ""
   
    var powerOn = false
    
    // timer used to retry to scan for peripheral, when we don't find it
    var rescanTimer: Timer?
    
    var delegate: BLEPeripheralProtocol?
    
    
    // 1°) start CentralManager
    //
    func startBLEPeripheral(name: String) {
        peripheralDiscoverableName = name
        
        aelog("start Peripheral")
        aelog("Discoverable name : " + name)

        // start the Bluetooth periphal manager
        localPeripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    // Stop advertising.
    // TODO : close the comunication ???
    //
    func stopBLEPeripheral() {
        aelog("Stop advertising")
        aelog("Stop peripheral Service")

        stopServices()
    }
    

    
    
    
    // Stop service, when powered off
    //
    func stopServices() {
        aelog("Stopping BLE services...")
        self.localPeripheralManager.removeAllServices()
        self.localPeripheralManager.stopAdvertising()
    }
    
    

    
    
    // delegate
    //
    // 2°) Receive some update from bluetooth state : when device is set on, or off
    //
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager)
    {
        if (peripheral.state == CBManagerState.poweredOff) {
            // Bluetooth peripheral is off, sto all services
            aelog("peripheral is off")
            self.powerOn = false
            self.stopServices()
        }
        else {
            // Bluetooth peripheral is on, will start the services
            aelog("peripheral is on")
            self.powerOn = true
            self.startServices()
        }
        
        // Call delegate for parent (viewController ???)
        //Tools.sendNotification(name: "BlueToothStatusUpdate", objectName: "peripheral", object: peripheral)
        
        // Send the status to delegate subscribed
        if delegate != nil {
            delegate?.BlueToothStatus(peripheral: peripheral)
        }
    }

    
    // 3°) Create 1 service
    // 2 Characteristics : 1 for read, 1 for write. or 1 characteristic read/write
    //
    func startServices() {
        aelog("starting services")
        aelog("Service UUID: " + BLEGenericService)
        aelog("Characteristic: read UUID: " + BLERead)
        aelog("Characteristic: write UUID: " + BLEWrite)
        
        // read characteristic
        let characteristic1UUID = CBUUID(string: BLERead)
        let properties: CBCharacteristicProperties = [.read, ] //.notify,
        let permissions: CBAttributePermissions = [.readable]
        let characteristic1 = CBMutableCharacteristic(type: characteristic1UUID, properties: properties, value: nil, permissions: permissions)
        
        // write characteristic
        let characteristic2UUID = CBUUID(string: BLEWrite)
        let properties2: CBCharacteristicProperties = [.write]
        let permissions2: CBAttributePermissions = [.writeable]
        let characteristic2 = CBMutableCharacteristic(type: characteristic2UUID, properties: properties2, value: nil, permissions: permissions2)
        
        // define the service
        let serviceUUID = CBUUID(string: BLEGenericService)
        let service = CBMutableService(type: serviceUUID, primary: true)
        
        // Create the service, add the characteristic to it
        service.characteristics = [characteristic1, characteristic2]
        createdService = service
        
        // push the service to the peripheral
        localPeripheralManager.add(service)
    }

    
    
    // 4°) service + Charactersitic added to peripheral
    //
    func peripheralManager(_ peripheral: CBPeripheralManager,
                           didAdd service: CBService,
                           error: Error?){
        
        if error != nil {
            aelog(("Error adding services: \(error?.localizedDescription)"))
        }
        else {
            aelog("service added to peripheral")
            
            // Save service locally, used later to advertise
            localService = service
            
            //let identifier = Bundle.main.bundleIdentifier!
            //aelog("Bundle Identifier: " + Tools.toString(identifier))
            //let manufacturerData = identifier.data( using: String.Encoding.utf8, allowLossyConversion: false)
//            let advertisement: [String : Any] = CBAdvertisementDataManufacturerDataKey : manufacturerData,
//                CBAdvertisementDataServiceUUIDsKey : [service.uuid]]
            
            // Create an advertisement, using the service UUID
            let advertisement: [String : Any] = [CBAdvertisementDataLocalNameKey: self.peripheralDiscoverableName,
                                                 //CBAdvertisementDataManufacturerDataKey : manufacturerData,
                                                 CBAdvertisementDataServiceUUIDsKey : [service.uuid]]
            // start the advertisement
            self.localPeripheralManager.startAdvertising(advertisement)
            
            aelog("Starting to advertise.")
        }
    }
    
    
    // Advertising done
    //
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager,
                                              error: Error?){
        if error != nil {
            aelog(("Error while advertising: \(error?.localizedDescription)"))
        }
        else {
            aelog("adversiting done. no error")
        }
        //peripheral.stopAdvertising()
    }
    
    
    // called when CBCentral manager request to read
    //
    func peripheralManager(_ peripheral: CBPeripheralManager,
                           didReceiveRead request: CBATTRequest) {
        
        aelog("CB Central Manager request from central: ")
        print(request)
        
//        if request.characteristic.UUID.isEqual(characteristic.UUID)
//        {
//            // Set the correspondent characteristic's value
//            // to the request
//            request.value = characteristic.value
//
//            // Respond to the request
//            localPeripheralManager.respond(
//                to: request,
//                withResult: .success)
//        }
        //peripheral.respond(to: request, withResult: CBATTError.success)
    }
    

    // called when central manager write value to peripheral manager
    // a popup appear before that, asking to pair device : "jumelage avec ..."
    //
    public func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        aelog("CB Central Manager request write from central: ")

        if requests.count > 0 {
            let str = NSString(data: requests[0].value!, encoding:String.Encoding.utf8.rawValue)!
            aelog("value sent by central Manager : " + String(describing: str))
        }
    }
    
    func respond(to request: CBATTRequest, withResult result: CBATTError.Code) {
        print("respnse requested")
    }
    
    
    
    
//    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest)
//    {
//        if request.characteristic.UUID.isEqual(characteristic.UUID)
//        {
//            // Set the correspondent characteristic's value
//            // to the request
//            request.value = characteristic.value
//            
//            // Respond to the request
//            peripheralManager.respondToRequest(
//                request,
//                withResult: .Success)
//        }
//    }
    
    
    
    //        // Every xxx second : if no peripheral == peripheralSearchedName is found, retry to scan
    //        rescanTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self,
    //                                           selector: #selector(BLEPeripheralManager.refreshAdvertising), userInfo: nil, repeats: true)
    
    //    // will refresh : To be defined
    //    func refreshAdvertising() {
    //        DispatchQueue.main.async {
    //            if self.localService != nil && self.powerOn {
    //                //Logs.info(message: "Advertise as: " + self.peripheralDiscoverableName)
    //                //let advertisement: [String : Any] = [self.peripheralDiscoverableName : BLEGenericService]
    //
    //                //self.localPeripheralManager.startAdvertising(advertisement)
    //            }
    //
    //        }
    //    }
    
    
    
    
}



