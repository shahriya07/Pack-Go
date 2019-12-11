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

        let loadedData = message["pokemonData"]

        let loadedPokemon = NSKeyedUnarchiver.unarchiveObject(with: loadedData as! Data) as? [PackLads]

        packLads = loadedPokemon!

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
        super.willActivate()
        
        if (WCSession.default.isReachable) {
            let message = ["getPokemonData": [:]]
            WCSession.default.sendMessage(message, replyHandler: { (result) -> Void in
                
                if result["pokemonData"] != nil
                {
                    let loadedData = result["pokemonData"]
                    
                    NSKeyedUnarchiver.setClass(PackLads.self, forClassName: "PackLads")
                    
                    let loadedPokemon = NSKeyedUnarchiver.unarchiveObject(with: loadedData as! Data) as? [PackLads]
                    
                    self.packLads = loadedPokemon!
                    
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
                        
                        row.lblName.setText(pack.pokemonName!)
                        row.imgPack.setImageNamed(pack.imageName!)
                    
                    }
                }
                
            }, errorHandler: { (error) -> Void in
                // TODO: Handle error - iPhone many not be reachable
                print(error)
            })
            
        }
        
    }

    
    
    
}
