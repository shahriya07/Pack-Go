//
//  BattleViewController.swift
//  Pack-Go
//
//  Created by Xcode User on 2019-10-26.
//  Copyright © 2019 Xcode User. All rights reserved.
//

import UIKit
import SpriteKit

class BattleViewController: UIViewController {
    
    var pokemon: Pokemon!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = BattleScene(size: CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height))
        self.view = SKView()
        
        let skView = self.view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = false
        
        scene.pokemon = self.pokemon
        scene.scaleMode = .aspectFill
        
        skView.presentScene(scene)

        // Do any additional setup after loading the view.
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
