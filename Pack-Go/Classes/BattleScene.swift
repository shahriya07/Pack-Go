//
//  BattleScene.swift
//  Pack-Go
//
//  Created by Xcode User on 2019-10-26.
//  Copyright © 2019 Xcode User. All rights reserved.
//

import SpriteKit
import UIKit

class BattleScene: SKScene, SKPhysicsContactDelegate{
    
    var pokemon: Pokemon!
    var pokemonSprite: SKSpriteNode!
    var pokeball: SKSpriteNode!
    
    //constants
    let kPokemonSize = CGSize(width: 100, height: 100)
    let kPokemonName = "pokemon"
    
    override func didMove(to view: SKView) {
        let battlebg = SKSpriteNode(imageNamed: "grass")
        battlebg.size = self.size
        battlebg.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        battlebg.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        battlebg.zPosition = -1
        
        self.addChild(battlebg)
        
        self.perform(#selector(pokemonSetup), with: nil, afterDelay: 1.0)
        self.perform(#selector(pokeballSetup), with: nil, afterDelay: 1.0)
    }
    
    @objc func pokemonSetup(){
        self.pokemonSprite = SKSpriteNode(imageNamed: pokemon.imageName!)
        self.pokemonSprite.size = kPokemonSize
        self.pokemonSprite.name = kPokemonName
        self.pokemonSprite.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        
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
        self.addChild(self.pokeball)
    }
    
}
