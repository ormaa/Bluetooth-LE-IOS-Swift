//
//  Tools_MACOS.swift
//  CentralManager_MacOS
//
//  Created by olivier Robin on 16/07/2018.
//  Copyright © 2018 fr.ormaa. All rights reserved.
//

import Foundation
import SystemConfiguration

class Tools {
    
    
    // convert string into Bool or Double
    //
    static func string2Bool(value: String) -> Bool {
        if let b = Bool(value) {
            return b
        }
        return true
    }
    static func string2Double(value: String) -> Double {
        if let b = Double(value) {
            return b
        }
        return 0.5
    }
    static func string2Float(value: String) -> Double {
        if let b = Double(value) {
            return b
        }
        return 0.5
    }
    
    
    // Return a string, even if nil
    //
    static func toString(_ txt: String?) -> String {
        if (txt == nil) {
            return "???"
        }
        else {
            return txt!
        }
    }



}
