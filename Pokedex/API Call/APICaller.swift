//
//  APICaller.swift
//  Pokedex
//
//  Created by Ekrem on 24.03.2023.
//

import Foundation

class webservice {
    
    var pokemon: [PokemonListResult] = []
    var pokemonListResult: [PokemonListResult] = []
    let pokemonListURL = "https://pokeapi.co/api/v2/pokemon?limit=151"
    
    
    func loadPokeList(url: URL, completion: @escaping ([PokemonListResult]?) -> ()) {
        
        guard let url = URL(string: pokemonListURL) else {
            
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                
                print(error.localizedDescription)
                
                completion(nil)
                
            } else if let data = data {
                
                let entries = try? JSONDecoder().decode([PokemonListResults].self, from: data)
                
                print(entries)
                
                
                
            }
            
        }.resume()
    }
}
 

