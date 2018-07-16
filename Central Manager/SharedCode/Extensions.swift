//
//  Extensions.swift
//  
//
//  Created by Olivier Robin on 08/02/2017.
//  Copyright © 2017 fr.ormaa. All rights reserved.
//

import Foundation




extension TimeInterval {
    var minuteSecond: String {
        return String(format:"%d m %02d s", minute, second)
        //        return String(format:"%d:%02d.%03d", minute, second, millisecond)
    }
    var SecondMS: String {
        //return String(format:"%d min %02d sec", minute, second)
        return String(format:"%d m %02d s %03d", minute, second, millisecond)
    }
    
    var minute: Int {
        return Int((self/60.0).truncatingRemainder(dividingBy: 60))
    }
    var second: Int {
        return Int(self.truncatingRemainder(dividingBy: 60))
    }
    var millisecond: Int {
        return Int((self*1000).truncatingRemainder(dividingBy: 1000) )
    }
}

extension Int {
    var msToSeconds: Double {
        return Double(self) / 1000
    }
}


