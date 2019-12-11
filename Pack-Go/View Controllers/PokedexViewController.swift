//
//  PokedexViewController.swift
//  Pack-Go
//
//  Created by Xcode User on 2019-10-25.
//  Copyright © 2019 Xcode User. All rights reserved.
//

import UIKit
import WatchConnectivity
import AVFoundation

class PokedexViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WCSessionDelegate {
    @IBOutlet var tableView: UITableView!
    
    var audioPlayer = AVAudioPlayer()
    
    var caughtPokemon : [Pokemon] = []
    var uncaughtPokemon : [Pokemon] = []
    var packLads : [PackLads] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playSound(file: "table", ext: "mp3")
        
        if (WCSession.isSupported()) {
            let session = WCSession.default
            session.delegate = self
            session.activate()
            
            if session.isPaired != true {
                print("Apple Watch is not paired")
            }
            
            if session.isWatchAppInstalled != true {
                print("WatchKit app is not installed")
            }
        } else {
            print("WatchConnectivity is not supported on this device")
        }
        initFakeDetails()
        
        let username = UserDefaults.standard.object(forKey: "loggedUser") ?? ""
        
        caughtPokemon = getUsersCaughtPokemons(username: username as! String)
        uncaughtPokemon = getUsersUncaughtPokemons(username: username as! String)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        print("Caught: \(caughtPokemon.count)")
        print("Uncaught: \(uncaughtPokemon.count)")

        // Do any additional setup after loading the view.
    }
    
    func playSound(file:String, ext:String) -> Void {
        do {
            let url = URL.init(fileURLWithPath: Bundle.main.path(forResource: file, ofType: ext)!)
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            audioPlayer.numberOfLoops = 10
        } catch let error {
            NSLog(error.localizedDescription)
        }
    }
    
    @IBAction func backToMap(_ sender: Any) {
        
        //Back to mapkit
        self.audioPlayer.stop()
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return self.caughtPokemon.count
        }
        else{
            return self.uncaughtPokemon.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)
        
        var pokemon : Pokemon
        if indexPath.section == 0{
            pokemon = self.caughtPokemon[indexPath.row]
        }
        else{
            pokemon = self.uncaughtPokemon[indexPath.row]
        }
        
        cell.textLabel?.text = pokemon.pokemonName
        cell.imageView?.image = UIImage(named: pokemon.imageName!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0{
            return "Caught Pokemons"
        }
        else{
            return "Uncaught Pokemons"
        }
    }
    
    
    func initFakeDetails()
    {
        // ***
        // WORK IN PROGRESS
        // ***
        
        
        /*  let dateStringFormatFrom = "EEE, MMM dd, hh:mm"
         let dateStringFormatTo = "hh:mm"
         let dateFormatterFrom = DateFormatter()
         let dateFormatterTo = DateFormatter()
         dateFormatterFrom.dateFormat = dateStringFormatFrom
         dateFormatterTo.dateFormat = dateStringFormatTo
         */
        
//        let progObj = ProgramObject()
//        progObj.initWithData(title: "Far and away", speaker: "Jim Kirk", from: "Fri, Oct 21, 3:15", to:"4:00", details: "Jim Kirk will speak about something cool, far and away")
//        programs.append(progObj)
//
//        let progObj2 = ProgramObject()
//        progObj2.initWithData(title: "Slow and steady", speaker: "Mr Spock", from:"Fri, Oct 21, 4:15", to: "5:00", details: "Mr Spock is going to talk about being slow and steady.")
//        programs.append(progObj2)
//
//        let progObj3 = ProgramObject()
//        progObj3.initWithData(title: "Old and boring", speaker: "Mr Scott", from:  "Fri, Oct 21, 5:15", to: "6:00", details: "Mr Spock and Mr Scott have spoken about cool things")
//        programs.append(progObj3)
//
//        let progObj4 = ProgramObject()
//        progObj4.initWithData(title: "Why Me?", speaker: "Uhura", from: "Fri, Oct 21, 6:15", to: "7:00", details: "Uhura will talk about some crazy things...in Klingon!")
//        programs.append(progObj4)
//
//        // step 6h - send data to watch.
//        let programData = NSKeyedArchiver.archivedData(withRootObject: programs)
//        sendWatchMessage(programData)
//
    }
    
    
    
    // step 7 - implemente the watch connectivity delegate interface and methods
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    // step 8 implement this method to handle messages from the watch.
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        
        var replyValues = Dictionary<String, AnyObject>()
        
        
        if (message["getProgData"] != nil)
        {
            // step 8b - serialize and send the fake data to the watch for display
            // note line of code below needed to prevent app crash.
            NSKeyedArchiver.setClassName("PackLads", for: PackLads.self)
            let programData = NSKeyedArchiver.archivedData(withRootObject: packLads)
            
            
            replyValues["progData"] = programData as AnyObject?
            replyHandler(replyValues)
        }
    }
}
