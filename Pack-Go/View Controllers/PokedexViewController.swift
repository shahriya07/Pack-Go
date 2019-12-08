//
//  PokedexViewController.swift
//  Pack-Go
//
//  Created by Xcode User on 2019-10-25.
//  Copyright © 2019 Xcode User. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet var tableView: UITableView!
    
    var caughtPokemon : [Pokemon] = []
    var uncaughtPokemon : [Pokemon] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        caughtPokemon = getCaughtPokemon()
        uncaughtPokemon = getUncaughtPokemon()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        print("Caught: \(caughtPokemon.count)")
        print("Uncaught: \(uncaughtPokemon.count)")

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backToMap(_ sender: Any) {
        
        //Back to mapkit
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
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
