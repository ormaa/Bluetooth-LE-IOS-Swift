//
//  ViewController.swift
//  BlueToothPeripheral
//
//  Created by Olivier Robin on 30/10/2016.
//  Copyright © 2016 fr.ormaa. All rights reserved.
//

import UIKit
import CoreBluetooth
import UserNotifications


class MyViewController: UIViewController, BLEPeripheralProtocol {
    
    @IBOutlet weak var logTextView: UITextView!
    @IBOutlet weak var switchPeripheral: UISwitch!
    
    var refreshLogs: Timer?
    var ble: BLEPeripheralManager?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MyViewController viewDidLoad")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Activate / disActivate the peripheral
    @IBAction func switchPeripheralOnOff(_ sender: AnyObject) {

        if self.switchPeripheral.isOn {
            print("starting peripheral")
            ble = BLEPeripheralManager()
            ble?.delegate = self
            ble!.startBLEPeripheral()
        }
        else {
            print("stopping Peripheral")
        ble!.stopBLEPeripheral()
        }
    
    }


    

    func logToScreen(text: String) {
        print(text)
        
        var str = logTextView.text + "\n"
        str += text
        logTextView.text = str
    }
    
    
    
}

