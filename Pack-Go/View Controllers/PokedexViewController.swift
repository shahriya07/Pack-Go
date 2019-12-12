//
//  PokedexViewController.swift
//  Pack-Go
//
//  Created by Xcode User on 2019-10-25.
//  Copyright © 2019 Xcode User. All rights reserved.
//
// Done by Giriraj Bhagat

import UIKit
import WatchConnectivity
import AVFoundation

class PokedexViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WCSessionDelegate {
    
    var lastMessage: CFAbsoluteTime = 0
    @IBOutlet var tableView: UITableView!
    
    var audioPlayer = AVAudioPlayer()
    
    
    var caughtPokemon : [Pokemon] = []
    var uncaughtPokemon : [Pokemon] = []
    var packLads : [PackLads] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        playSound(file: "table", ext: "mp3")
        
        let username = UserDefaults.standard.object(forKey: "loggedUser") ?? ""
        caughtPokemon = getUsersCaughtPokemons(username: username as! String)
        uncaughtPokemon = getUsersUncaughtPokemons(username: username as! String)
        
        prepareDataSendToWatch()
        
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
    
    
    func prepareDataSendToWatch()
    {
        for pokemon in caughtPokemon {
            let poke = PackLads()
            poke.initWithData(pokemonName: pokemon.pokemonName!, imageName: pokemon.imageName!)
            packLads.append(poke)
        }
        
        let pokemonData = NSKeyedArchiver.archivedData(withRootObject: packLads)
        sendWatchMessage(pokemonData)
    }
    
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        var replyValues = Dictionary<String, AnyObject>()
        
        if (message["getPokemonData"] != nil)
        {
            // step 8b - serialize and send the fake data to the watch for display
            // note line of code below needed to prevent app crash.
            NSKeyedArchiver.setClassName("PackLads", for: PackLads.self)
            let pokemonData = NSKeyedArchiver.archivedData(withRootObject: packLads)
            
            replyValues["pokemonData"] = pokemonData as AnyObject?
            replyHandler(replyValues)
        }
    }
    
    
    func sendWatchMessage(_ msgData:Data) {
        let currentTime = CFAbsoluteTimeGetCurrent()
        
        // if less than half a second has passed, bail out
        if lastMessage + 0.5 > currentTime {
            return
        }
        
        // send a message to the watch if it's reachable
        if (WCSession.default.isReachable) {
            
            let message = ["pokemonData": msgData]
            WCSession.default.sendMessage(message, replyHandler: nil)
        }
        
        // update our rate limiting property
        lastMessage = CFAbsoluteTimeGetCurrent()
    }
}
