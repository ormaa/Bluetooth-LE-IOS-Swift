//import UIKit

import Foundation

//Model singleton so that we can refer to this from throughout the app.
let appControllerSingletonGlobal = Singleton()


// this class is a singleton
//
class Singleton: NSObject {

    class func sharedInstance() -> Singleton {
        return appControllerSingletonGlobal
    }
    

    
    // used by BLE stack
    let serialQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default) //DispatchQueue(label: "my serial queue")
    
    // Be careful. those class cannot use appController, because it would be a cyclic redundance
    let bluetoothController = BluetoothController()
    let tools = Tools()
    
    // App restore after IOS killed it, and bluetooth status has changed : device switch on, or advertise something.
    var appRestored = false
    var centralManagerToRestore: String?
    
    // logger
    let logger = Log()
    
    
}

