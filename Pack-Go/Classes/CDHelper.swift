//
//  CDHelper.swift
//  Pack-Go
//
//  Created by Xcode User on 2019-10-26.
//  Copyright © 2019 Xcode User. All rights reserved.
//

import CoreData
import UIKit

func createAllPokemons(){
    
    createPokemon(name: "Pikachu", withThe: "pikachu")
    createPokemon(name: "Charmander", withThe: "charmander")
    createPokemon(name: "Bullbasaur", withThe: "bullbasaur")
    createPokemon(name: "JigglyPuff", withThe: "jiggly")
    createPokemon(name: "Squirtle", withThe: "squirtle")
    createPokemon(name: "Kadabra", withThe: "kadabra")
    createPokemon(name: "Snorlax", withThe: "snorlax")
    createPokemon(name: "Psyduck", withThe: "duck")
    createPokemon(name: "Eevee", withThe: "eeve")
    createPokemon(name: "Meowth", withThe: "mewoth")
    createPokemon(name: "Mewtwo", withThe: "mew")
    
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
    
}

func createPokemon(name: String, withThe imageName: String){
    
    //to excess the database
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let pokemon = Pokemon(context: context)
    pokemon.pokemonName = name
    pokemon.imageName = imageName
    
}

//fetching all pokemons from database
func showPokemons() -> [Pokemon] {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    do{
        let pokemons = try context.fetch(Pokemon.fetchRequest()) as! [Pokemon]
        
        if pokemons.count == 0{
            createAllPokemons()
            return showPokemons()
        }
        return pokemons
    }
    catch{
        print("Error")
    }
    
    return []
}

func getCaughtPokemon() -> [Pokemon]{
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    fetchRequest.predicate = NSPredicate(format: "numberOfTimeCaught > %d", 0)
    
    do{
       let pokemons = try context.fetch(fetchRequest) as! [Pokemon]
        return pokemons
    }
    catch{
        print("Error")
    }
    
    return []
}

func getUncaughtPokemon() -> [Pokemon]{
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let fetchRequest = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    fetchRequest.predicate = NSPredicate(format: "numberOfTimeCaught == %d", 0)
    
    do{
        let pokemons = try context.fetch(fetchRequest) as! [Pokemon]
        return pokemons
    }
    catch{
        print("Error")
    }
    
    return []
}
