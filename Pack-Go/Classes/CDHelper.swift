//
//  CDHelper.swift
//  Pack-Go
//
//  Created by Xcode User on 2019-10-26.
//  Copyright © 2019 Xcode User. All rights reserved.
// done by Riya Shah

import CoreData
import UIKit

func getUsersCaughtPokemons(username: String) -> [Pokemon]{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let user = User(context: context)
    user.username = nil
    
    let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
    userFetch.predicate = NSPredicate(format: "username == %@", username)
    
    do {
        let users = try  context.fetch(userFetch) as! [User]
        
        if users.count == 0{
            return []//shouldneverhappen
        } else {
            return users[0].pokemons!.allObjects as! [Pokemon]
        }
        
    } catch {
        return []
    }
}


func getUsersUncaughtPokemons(username: String) -> [Pokemon]{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let user = User(context: context)
    user.username = nil
    
    var allPokemons = showPokemons()
    
    let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
    userFetch.predicate = NSPredicate(format: "username == %@", username)
    
    do {
        let users = try  context.fetch(userFetch) as! [User]
        if users.count == 0{
            return [] //shouldneverhappen
        } else {
            //this is a mess lol
            for pokemon in users[0].pokemons!.allObjects as! [Pokemon] {
                allPokemons = allPokemons.filter { $0 != pokemon }
            }
            return allPokemons
        }
        
    } catch {
        return []
    }
    
}

func getAllUsernames() -> [User]{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    do {
        let user = try context.fetch(User.fetchRequest()) as! [User]
        if user.count == 0 {
            return []
        } else {
            return user
        }
    } catch {
        return []
    }
}

func getUserLoginInformation(username: String, password: String) -> User {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let user = User(context: context)
    user.username = nil

    let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
    userFetch.predicate = NSPredicate(format: "username == %@", username)
    
    do {
        let users = try  context.fetch(userFetch) as! [User]

        if users.count == 0{
            return user
        } else {
            return users[0]
        }

    } catch {
        return user
    }

}

func insertUser(user: String, pass: String){
    createUser(username: user, password: pass)
    
    (UIApplication.shared.delegate as! AppDelegate).saveContext()
}

func createUser(username: String, password: String) {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let user = User(context: context)
    user.username = username
    user.password = password
    user.score = 0
    user.addToPokemons([])
    
}

func createAllPokemons(){
    
    createPokemon(name: "Pikachu", withThe: "pikachu")
    createPokemon(name: "Charmander", withThe: "charmander")
    createPokemon(name: "Bullbasaur", withThe: "bullbasaur")
    createPokemon(name: "JigglyPuff", withThe: "jiggly")
    createPokemon(name: "Squirtle", withThe: "squirtle")
    createPokemon(name: "Kadabra", withThe: "kadabra")
    createPokemon(name: "Snorlax", withThe: "snorlax")
    createPokemon(name: "Psyduck", withThe: "duck")
//    createPokemon(name: "Eeve", withThe: "eeve")
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
