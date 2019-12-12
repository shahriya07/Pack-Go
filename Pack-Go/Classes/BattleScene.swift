//
//  BattleScene.swift
//  Pack-Go
//
//  Created by Xcode User on 2019-10-26.
//  Copyright © 2019 Xcode User. All rights reserved.
// Done by Giriraj Bhagat

import SpriteKit
import UIKit

class BattleScene: SKScene, SKPhysicsContactDelegate{
    
    var pokemon: Pokemon!
    var loggedInUser: User!
    var pokemonSprite: SKSpriteNode!
    var pokeball: SKSpriteNode!
    
    //constants
    let kPokemonSize = CGSize(width: 100, height: 100)
    let kPokemonName = "pokemon"
    
    // bit categories
    let kPokemonCategory: UInt32 = 0x1 << 0
    let kPokeballCategory: UInt32 = 0x1 << 1
    let kEdgeCategory: UInt32 = 0x1 << 2
    
    var velocity: CGPoint = CGPoint.zero
    var touchPoint: CGPoint = CGPoint()
    var canThrowPokeball = false
    
    
    var startCount = true
    var maxTime = 30
    var myTime = 30
    var timeLabel = SKLabelNode(fontNamed: "arial")
    var pokemonCaught = false
    
    override func didMove(to view: SKView) {
        let battlebg = SKSpriteNode(imageNamed: "grass")
        battlebg.size = self.size
        battlebg.position = CGPoint(x: self.size.width/2.2, y: self.size.height/2)
        battlebg.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        battlebg.zPosition = -1
        
        
        self.addChild(battlebg)
        
        self.makeMessageWith(imageName: "battle")
        
        self.perform(#selector(pokemonSetup), with: nil, afterDelay: 1.0)
        self.perform(#selector(pokeballSetup), with: nil, afterDelay: 1.0)
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.categoryBitMask = kEdgeCategory
        self.physicsWorld.contactDelegate = self
        
        self.timeLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.9)
        self.addChild(self.timeLabel)
    }
    
    @objc func pokemonSetup(){
        self.pokemonSprite = SKSpriteNode(imageNamed: pokemon.imageName!)
        self.pokemonSprite.size = kPokemonSize
        self.pokemonSprite.name = kPokemonName
        self.pokemonSprite.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        
        //pokemon physics
        self.pokemonSprite.physicsBody = SKPhysicsBody(rectangleOf: kPokemonSize)
        self.pokemonSprite.physicsBody?.isDynamic = false
        self.pokemonSprite.physicsBody?.affectedByGravity = false
        self.pokemonSprite.physicsBody?.mass = 1.0

        //pokemon bitmask
        self.pokemonSprite.physicsBody?.categoryBitMask = kPokemonCategory
        self.pokemonSprite.physicsBody?.contactTestBitMask = kPokeballCategory
        self.pokemonSprite.physicsBody?.collisionBitMask = kEdgeCategory
        
        //Actions
        let moveRight = SKAction.moveBy(x: 150, y: 0, duration: 3.0)
        let sequence = SKAction.sequence([moveRight, moveRight.reversed(), moveRight.reversed(), moveRight])
        
        self.pokemonSprite.run(SKAction.repeatForever(sequence))
        self.addChild(self.pokemonSprite)
    }
    
    @objc func pokeballSetup(){
        self.pokeball = SKSpriteNode(imageNamed: "pokeball")
        self.pokeball.size = kPokemonSize
        self.pokeball.name = kPokemonName
        self.pokeball.position = CGPoint(x: self.size.width/2, y: 50)
        
        self.pokeball.physicsBody = SKPhysicsBody(circleOfRadius:  self.pokeball.frame.size.width/2)
        self.pokeball.physicsBody?.isDynamic = true
        self.pokeball.physicsBody?.affectedByGravity = true
        self.pokeball.physicsBody?.mass = 0.1

        //pokeball bitmask
        self.pokeball.physicsBody?.categoryBitMask = kPokeballCategory
        self.pokeball.physicsBody?.contactTestBitMask = kPokemonCategory
        self.pokeball.physicsBody?.collisionBitMask = kPokemonCategory | kEdgeCategory
        
        
        
        self.addChild(self.pokeball)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self)

        if self.pokeball.frame.contains(location!){
            self.canThrowPokeball = true
            self.touchPoint = location!

        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self)
        self.touchPoint = location!

        if  self.canThrowPokeball{
            throwBall()
        }
    }
    
    func throwBall(){
        
        self.canThrowPokeball = false
        let dt: CGFloat = 1.0/50
        let distance = CGVector(dx: self.touchPoint.x - self.pokeball.position.x, dy: self.touchPoint.y - self.pokeball.position.y)
        let velocity = CGVector(dx: distance.dx / dt, dy: distance.dy / dt)
        self.pokeball.physicsBody?.velocity = velocity
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch contactMask {
        case kPokemonCategory | kPokeballCategory:
                print("Pokemon has been Captured")
                self.pokemonCaught = true
                endGame()
        default:
            return
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if self.startCount{
            self.maxTime = Int(currentTime) + self.maxTime
            self.startCount = false
        }
        
        self.myTime = self.maxTime - Int(currentTime)
        self.timeLabel.text = "\(self.myTime)"
        
        if self.myTime <= 0 {
            endGame()
        }
    }
    
    func endGame(){
        
        self.pokemonSprite.removeFromParent()
        self.pokeball.removeFromParent()
        
        if pokemonCaught{
            self.makeMessageWith(imageName: "gotcha")
            self.pokemon.numberOfTimeCaught += 1
            
            self.loggedInUser.addToPokemons(self.pokemon!)
            // modify user to have pokemons in user.pokemons
            
             (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
        else{
            self.makeMessageWith(imageName: "footprint")
        }
        self.perform(#selector(self.endBattle), with: nil, afterDelay: 1.0)
    }
    
    @objc func endBattle(){
        NotificationCenter.default.post(name: NSNotification.Name("closeBattle"), object: nil)
    }
    
    func makeMessageWith(imageName: String){
        let message = SKSpriteNode(imageNamed: imageName)
        message.size = CGSize(width: 150, height: 150)
        message.position = CGPoint(x: self.size.width/2, y: self.size.width/2)
        self.addChild(message)
        
        message.run(SKAction.sequence([SKAction.wait(forDuration: 1.0), SKAction.removeFromParent()]))
    }
    
}
