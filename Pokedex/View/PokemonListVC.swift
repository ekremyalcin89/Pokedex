//
//  ViewController.swift
//  Pokedex
//
//  Created by Ekrem on 24.03.2023.
//

import UIKit

class PokeDexListViewController: UITableViewController, UISearchBarDelegate  {
    
    
    // Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!

    // Properties
    var pokemon: [PokemonListResult] = []
    var pokemonListResult: [PokemonListResult] = []
    var searchText = ""
    let pokemonListURL = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=151")!

  
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        webservice().loadPokeList(url: pokemonListURL) { pokes in
            if let pokes = pokes {
                
            }
        }
    }

    //  Funcs
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        
        pokemonListResult.removeAll()

        pokemonListResult = pokemon.filter { $0.name.lowercased().contains(searchText.lowercased()) }

        self.tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPokemonSegue",
           let destination = segue.destination as? PokemonViewController,
           let index = tableView.indexPathForSelectedRow?.row {
            destination.url = searchText.isEmpty ?
                pokemon[index].url :
                pokemonListResult[index].url
        }
    }

    // Tableview Funcs
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchText.isEmpty ? pokemon.count : pokemonListResult.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)

        cell.textLabel?.text = self.searchText.isEmpty ?
            pokemon[indexPath.row].name.uppercased() :
            pokemonListResult[indexPath.row].name.uppercased()
        return cell
    }
}
