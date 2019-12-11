//
//  BattleViewController.swift
//  Pack-Go
//
//  Created by Xcode User on 2019-10-26.
//  Copyright © 2019 Xcode User. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class BattleViewController: UIViewController {
    
    var pokemon: Pokemon!
    var user: User!
    
    var audioPlayer = AVAudioPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        playSound(file: "battle", ext: "mp3")
        
        let username = UserDefaults.standard.object(forKey: "loggedUser") ?? ""
        user = getUserLoginInformation(username: username as! String, password: "")
        
        let scene = BattleScene(size: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.view = SKView()
        
        let skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = false
        
        scene.loggedInUser = self.user 
        scene.pokemon = self.pokemon
        scene.scaleMode = .aspectFill
        
        skView.presentScene(scene)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.returnToMap), name: NSNotification.Name("closeBattle"), object: nil)

        // Do any additional setup after loading the view.
    }
    
    func playSound(file:String, ext:String) -> Void {
        do {
            let url = URL.init(fileURLWithPath: Bundle.main.path(forResource: file, ofType: ext)!)
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch let error {
            NSLog(error.localizedDescription)
        }
    }
    
    @objc func returnToMap(){
        self.dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
