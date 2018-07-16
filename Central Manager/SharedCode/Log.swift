//
//  Log.swift
//  CentralManager
//
//  Created by Olivier Robin on 04/03/2017.
//  Copyright © 2017 fr.ormaa. All rights reserved.
//

import Foundation


class Log {

    let shared = UserDefaults(suiteName: "group.fr.ormaa")
    var logStr = ""
    
    // Delete log file
    func deleteLog() {
        shared?.removeObject(forKey: "group.fr.ormaa.central.log")
    }
    
    // save log to nsUserDefault.
    // This allow to use another app, with same group, in order to read what heppen
    // when this app is in background for example !
    //
    func saveLog(value: String) {
        shared?.setValue(value + "\n", forKey: "group.fr.ormaa.central.log")
    }

    // log an object
    //
    func log(_ text: Any?) {
        
        if text == nil {
            
        }
        else {
            let str = getDate() + " - " + String(describing: text! as Any)
            print(str)

            logStr += str + "\n"
            saveLog(value: logStr)
        }
    }
    
    // Format date, with milli seconds, and local time
    //
    func getDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .short
        formatter.timeZone = TimeZone.autoupdatingCurrent
        formatter.dateFormat = "y-MM-dd -- H:m:ss.SSSS"
        let dateStr = formatter.string(from: date)
        return dateStr
    }
    
    
}
