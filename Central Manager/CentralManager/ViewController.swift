//
//  ViewController.swift
//  CentralManager
//
//  Created by Olivier Robin on 04/03/2017.
//  Copyright © 2017 fr.ormaa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BLEProtocol {
    
    @IBOutlet weak var bleLogTextView: UITextView!

    var appDelegate:AppDelegate? = nil
    
    
    // this is the name of the peripheral that we are looking for.
    // change it as you want. but change it also on peripheral side.
    // note : if you want to connect using the main service of the peripheral : this peripheral need to advertise its service, in advertise area
    //
    //let peripheralName = "ORMAA_P1.0"
    let peripheralUUID = "00001901-0000-1000-8000-00805F9B34FB"
    let characRead = "2AC6A7BF-2C60-42D0-8013-AECEF2A124C0" //"00002B00-0000-1000-8000-00805F9B34FB"
    let characWrite = "9B89E762-226A-4BBB-A381-A4B8CC6E1105"

    var timerRead: Timer? = nil
    var timerWrite: Timer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        appDelegate =  UIApplication.shared.delegate as! AppDelegate?
        appDelegate!.singleton.logger.log("viewDidLoad")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        appDelegate!.singleton.logger.log("viewDidAppear")
        
        bleLogTextView.text = ""
    
        if appDelegate!.singleton.appRestored,
        let id = appDelegate!.singleton.centralManagerToRestore {

            log("View did appear, restore peropheral connection \(id)")
            
            appDelegate!.singleton.bluetoothController.restoreCentralManager(viewControllerDelegate: self, centralName: id )
        }
    }
    
    func log(_ object: Any?) {
        appDelegate?.singleton.logger.log(object)
    }
    
    // Add text to the UITextView
    func addText(text: String) {
        log(text)
        
        DispatchQueue.main.async {
            let txt = self.bleLogTextView.text + "\n"
            self.bleLogTextView.text = txt + text
        }
    }


    @IBAction func stopCentralManager(_ sender: Any) {
        self.appDelegate!.singleton.bluetoothController.stopCentralManager()

        self.bleLogTextView.text = ""
    }

    
    // user clicked on start central button
    @IBAction func startCentralClick(_ sender: Any) {
        log("start central click")
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            
            self.addText(text: "Starting central Manager")

            self.appDelegate!.singleton.bluetoothController.appDelegate = self.appDelegate      // TODO remove this ugly thing
            self.appDelegate!.singleton.bluetoothController.ble.appDelegate = self.appDelegate      // TODO remove this ugly thing

            if !self.appDelegate!.singleton.bluetoothController.startCentralManager(viewControllerDelegate: self) {
                // Display en error
                self.addText(text: "I believe that Bluetooth is off, because starting central manager return an error")
                return
            }

            self.addText(text: "central manager started. will search for peripheral : " + self.peripheralUUID)

            if !self.appDelegate!.singleton.bluetoothController.searchDevice(uuidName: self.peripheralUUID) {
                // Display en error
                self.addText(text: "The peripheral was not found, even after a while. check its name, and if it is near, and swithed on.\n please try again later.")
                return
            }
            
            self.addText(text: "peripheral : " + self.peripheralUUID + " discovered.")

            if !self.appDelegate!.singleton.bluetoothController.connectToDevice(uuid: self.peripheralUUID) {
                // Display en error
                self.addText(text: "Connection failed !!!")
                return
            }

            if !self.appDelegate!.singleton.bluetoothController.discoverServices() {
                self.addText(text: "discover service and characteristics failed !!!")
                return
            }
            
            self.addText(text: "services discovered")

            self.addText(text: "request notification for charac :\n" + self.characRead)
            self.appDelegate!.singleton.bluetoothController.requestNotify(uuid: self.characRead)

            self.addText(text: "\nRead a value from peripheral " + self.characRead)
            self.appDelegate?.singleton.bluetoothController.read(uuid: self.characRead)
            
            self.appDelegate?.singleton.bluetoothController.write(uuid: self.characWrite, message: "I am ok guy")
            self.addText(text: "\nwrite to peripheral : I am ok guy, char :" + self.characWrite)

            self.appDelegate?.singleton.bluetoothController.writeAsync(uuid: self.characWrite, message: "hello mate")
            self.addText(text: "\nwriteAsync to peripheral : hello mate, char :" + self.characWrite)

            // start some timer, which will read or write data from / to peripheral
            //self.timerRead = Timer.scheduledTimer(timeInterval: TimeInterval(2), target: self, selector: #selector(self.read), userInfo: nil, repeats: true)
            //self.timerWrite = Timer.scheduledTimer(timeInterval: TimeInterval(5), target: self, selector: #selector(self.write), userInfo: nil, repeats: true)
            
        }
    }
    
    
    func read() {
        self.addText(text: "Read value returned by peripheral : " + self.characRead)

        self.appDelegate?.singleton.bluetoothController.read(uuid: characRead)
        
    }
    
    
    
    // called by bluetooth stack
    //
    func valueRead(message: String) {
        self.addText(text: "Read : " + message)

    }
    
    func valueWrite(message: String) {
        self.addText(text: "write : " + message)
    }
    
    
    
    
    // disconnected : ble is too far away, or sitched off
    func disconnected(message: String) {
        self.addText(text: "\ndisconnected from peripheral : " + message)
    }
    
    
    
    // connection to ble failed
    func failConnected(message: String) {
        self.addText(text: "\nconnection to peripheral failed : " + message)
    }
    
    
    
    func connected(message: String) {
        self.addText(text: "\nconnected to peripheral : " + message + " - " + self.peripheralUUID)
    }
    

    
}

