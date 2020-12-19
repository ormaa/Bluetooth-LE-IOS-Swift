//
//  Tools.swift
//  
//
//  Created by Olivier Robin on 24/01/2017.
//  Copyright © 2017 fr.ormaa. All rights reserved.
//

import Foundation
import SystemConfiguration
import UIKit

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
    
    
    // Display an alert popup
    func simpleAlert(message: String) {

        if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first, let controller = window.rootViewController {

            DispatchQueue.main.async {
                let picker = UIAlertController(title: "Attention", message: message, preferredStyle: .alert)
                var action: UIAlertAction
                action = UIAlertAction(title: "OK", style: .default)
                
                picker.addAction(action)
                controller.present(picker, animated: true, completion: nil)
            }
        }
    }

    // Display an alert popup, use closure for returned value
    func simpleSyncAlert( message: String, completion:@escaping (_ message: String) -> Void) {

        if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first, let controller = window.rootViewController {
            
            let picker = UIAlertController(title: "Attention",
                                           message: message, preferredStyle: .alert)
            var action: UIAlertAction
            action = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                completion("ok")
            })

            picker.addAction(action)
            controller.present(picker, animated: true, completion: nil)
        }
    }

    // Display an alert popup, use closure for returned value
    func SyncAlert( message: String, completion:@escaping (_ retour: String) -> Void) {

        if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first, let controller = window.rootViewController {

            let picker = UIAlertController(title: "Attention", message: message, preferredStyle: .alert)
            var action: UIAlertAction
            action = UIAlertAction(title: "Oui", style: .default, handler: { (UIAlertAction) in
                completion("oui")
            })
            var action2: UIAlertAction
            action2 = UIAlertAction(title: "Non", style: .default, handler: { (UIAlertAction) in
                completion("non")
            })
            
            picker.addAction(action)
            picker.addAction(action2)
            controller.present(picker, animated: true, completion: nil)
        }
    }
    
 
}




