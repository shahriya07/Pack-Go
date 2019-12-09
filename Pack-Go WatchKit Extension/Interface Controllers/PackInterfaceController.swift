//
//  PackInterfaceController.swift
//  Pack-Go WatchKit Extension
//
//  Created by Lorraine Chong on 2019-12-09.
//  Copyright © 2019 Xcode User. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class PackInterfaceController: WKInterfaceController, WCSessionDelegate {
    @IBOutlet var packladsTable: WKInterfaceTable!
    var packLads : [PackLads] = []
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }


    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        
        var replyValues = Dictionary<String, AnyObject>()
        
        let loadedData = message["progData"]
        
        let loadedPerson = NSKeyedUnarchiver.unarchiveObject(with: loadedData as! Data) as? [PackLads]
        
        packLads = loadedPerson!
        
        replyValues["status"] = "PackLads Received" as AnyObject?
        replyHandler(replyValues)
    }
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if(WCSession.isSupported()){
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    //    override func willActivate() {
    //        // This method is called when watch view controller is about to be visible to user
    //        super.willActivate()
    //    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if (WCSession.default.isReachable) {
            
            // step 6c - send a message to the phone requesting data
            let message = ["getProgData": [:]]
            WCSession.default.sendMessage(message, replyHandler: { (result) -> Void in
                // TODO: Handle your data from the iPhone
                
                if result["progData"] != nil
                {
                    let loadedData = result["progData"]
                    
                    
                    // step 6d - deserialize the data from the watch
                    NSKeyedUnarchiver.setClass(PackLads.self, forClassName: "ProgramObject")
                    // causes app crash because decode not linked properly error
                    // above line of code needed to prevent this crash
                    let loadedPerson = NSKeyedUnarchiver.unarchiveObject(with: loadedData as! Data) as? [PackLads]
                    
                    self.packLads = loadedPerson!
                    
                    self.packladsTable.setNumberOfRows(self.packLads.count,
                                                   withRowType: "PackRowController")
                    
                    /*    let dateStringFormatFrom = "EEE, MMM dd, hh:mm"
                     let dateStringFormatTo = "hh:mm"
                     let dateFormatterFrom = DateFormatter()
                     let dateFormatterTo = DateFormatter()
                     dateFormatterFrom.dateFormat = dateStringFormatFrom
                     dateFormatterTo.dateFormat = dateStringFormatTo
                     */
                    // step 6e - format and add data to table cells
                    // now move back to iPhone to finish connectivity side there
                    for (index,pack) in self.packLads.enumerated() {
                        let row = self.packladsTable.rowController(at: index) as! PackRowController
                        
                        row.lblName.setText("")
                        row.lblType.setText("")
                        row.imgPack.setImageNamed("menuBackground.jpg")
//                        row.lblTitle.setText(prog.title)
//                        row.lblSpeaker.setText(prog.speaker)
//                        row.lblFrom.setText(prog.from)
//                        row.lblTo.setText(prog.to)
                    
                    }
                }
                
            }, errorHandler: { (error) -> Void in
                // TODO: Handle error - iPhone many not be reachable
                print(error)
            })
            
        }
        
    }

    
    
    
}
