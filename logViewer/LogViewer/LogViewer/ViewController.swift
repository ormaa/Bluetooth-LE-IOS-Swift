//
//  ViewController.swift
//  LogViewer
//
//  Created by Olivier Robin on 28/02/2017.
//  Copyright © 2017 fr.ormaa. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
   
    
    
    @IBOutlet weak var logTextView: UITextView!

    @IBOutlet weak var time: UILabel!
    
    var refreshLogs: Timer?
    let shared = UserDefaults(suiteName: "group.fr.ormaa")
    var logStr: String? = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        refreshLogs = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.refresh), userInfo: nil, repeats: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func refresh() {
        
        logStr = shared!.string(forKey: "group.fr.ormaa.central.log")
        let date = getDate()
        
        
        DispatchQueue.main.async {
            self.time.text = date //String(describing: Date())
            
            if self.logStr != nil {
            let str = self.logStr
            self.logTextView.text = str
            }
            else {
                self.logTextView.text = "nil"
            }

        }
    }
    
    func getDate() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .short
        formatter.timeZone = TimeZone.autoupdatingCurrent //.current
        formatter.dateFormat = "y-MM-dd -- H:m:ss.SSSS"
        let dateStr = formatter.string(from: date)
        //let dateValue = formatter.date(from: dateStr)?.addingTimeInterval(60)
        print("date: " + dateStr)
 
        return dateStr
    }
    
    
    
    @IBAction func clearClick(_ sender: Any) {
        shared?.removeObject(forKey: "group.fr.ormaa.log")
        
    }
    
}

