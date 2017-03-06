//
//  BLEProtocol.swift
//  CentralManager
//
//  Created by Olivier Robin on 04/03/2017.
//  Copyright © 2017 fr.ormaa. All rights reserved.
//

import Foundation


protocol BLEProtocol {
    
    func disconnected(message: String)
    func failConnected(message: String)
    func connected(message: String)
    func valueRead(message: String)
    func valueWrite(message: String)

}
