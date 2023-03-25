//
//  APICaller.swift
//  Pokedex
//
//  Created by Ekrem on 23.03.2023.
//



import UIKit

class Service {
    
    static let instance = Service()
    let BASE_URL = "https://pokeapi.co/api/v2/pokemon/?offset=0&limit=40"
    
    func fetchPokemon(completion: @escaping ([Pokemon]) -> ()) {
        
        var pokemonArray = [Pokemon]()
        
        guard let url = URL(string: BASE_URL) else { return }
        
        URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            
            // Handle error
            if let error = error {
                print("Failed to fetch data: ", error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            do {
                guard let resultArray = try JSONSerialization.jsonObject(with: data, options: []) as? [AnyObject] else { return }
                
                for (key, result) in resultArray.enumerated() {
                    if let dictionary = result as? [String: AnyObject] {
                        let pokemon = Pokemon(id: key, dictionary: dictionary)
                        guard let imageUrl = pokemon.imageUrl else { return }
                        
                        
                        self.fetchImage(withUrlString: imageUrl, completion: { (image) in
                            pokemon.image = image
                            pokemonArray.append(pokemon)
                            
                            pokemonArray.sort(by: { (poke1, poke2) -> Bool in
                                poke1.id! < poke2.id!
                            })
                            
                            completion(pokemonArray)
                        })
                        
                    }
                    
                }

                
            } catch let error {
                print("Failed to create json: ", error.localizedDescription)
            }
        }).resume()
        
    }
    
    private func fetchImage(withUrlString urlString: String, completion: @escaping (UIImage) -> ()) {
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // Handle error
            if let error = error {
                print("Failed to fetch image: ", error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }
            completion(image)
            
        }.resume()
        
    }
    
}
