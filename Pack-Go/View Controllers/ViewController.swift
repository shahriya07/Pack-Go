//
//  ViewController.swift
//  Pack-Go
//
//  Created by Xcode User on 2019-10-25.
//  Copyright © 2019 Xcode User. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController{
    
    var audioPlayer = AVAudioPlayer()
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        playSound(file: "title", ext: "mp3")
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


}

