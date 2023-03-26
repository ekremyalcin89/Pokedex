//
//  PokemonVC.swift
//  Pokedex
//
//  Created by Ekrem on 23.03.2023.
//

import UIKit

private let reuseIdentifier = "NameCell"

class TableViewController: UITableViewController {
    
    var pokemon:                    [Result] = []
    var sprite:                     Sprite?
    
    // Holds list of sprite URLs to be passed to the nameCell class
    var spriteURLList:              [String] = []
    var sprites:                    [UIImage] = []
    var count =                     0
    
    var nameURL:                    String?
    var imageURL:                   String?
    
    // Cell tapped data
    var pokemonNumber:              Int?
    var pokemonBaseExp:             Int?
    var pokemonType:                [type] = []
    var pokemonTypeDetails:         [String] = []
    var pokemonAbilities:           [Ability] = []
    var pokemonAbilityDetails:      [Ability] = []
    
    @IBOutlet weak var nameLabel:   UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
        title = "Pokédex"
        
        
        loadNameData()
        loadImageURL()

    }
    
    // loops through grabbing pokemon name data
    func loadNameData() {
        // loop runs 55 times as there is 20 Pokemon per page and 1118 Pokemon in total
        for _ in 0...55 {
            nameURL = "https://pokeapi.co/api/v2/pokemon?limit=40&offset=0"
            count += 20
            
            // This is the actual network call which collects the data
            if let url = URL(string: nameURL!) {
                if let data = try? Data(contentsOf: url) {
                    parse(json: data)
                }
            }
        }
    }
    
    // Loops through appending the image png URL to spriteURLList array.
    // This is so each url can be passed to NameCell class in order for it
    // to parse the image JSON.
    func loadImageURL() {
        var spriteIndex = 0
        for index in 1...1118 {
            
            imageURL = "https://pokeapi.co/api/v2/pokemon-form/\(index)/"
            spriteURLList.append(imageURL!)
            spriteIndex += 1
        }
    }
    
    // Parses the name JSON and appends it to the Pokemon Array
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonResults = try? decoder.decode(Results.self, from: json) {
            
            pokemon.append(contentsOf: jsonResults.results)
        }
    }
     
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pokemon.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? NameCell else {
            fatalError("Unable to dequeue NameCell")
        }
        
        let pokemon = pokemon[indexPath.row]
        let url = spriteURLList[indexPath.row]

        cell.nameLabel.text = pokemon.name
        cell.networkCall(imageURL: url)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pokemon = pokemon[indexPath.row]
        let url = spriteURLList[indexPath.row]
        
        // Parses the selected pokemon data
        cellToBePassedTappedData(pokeURL: pokemon.url)
        
        guard let vc = self.storyboard?.instantiateViewController(identifier: "DetailViewController", creator: { [self] coder in
            return DetailViewController (coder: coder, name: pokemon.name, number: pokemonNumber!, spriteURL: url, experience: pokemonBaseExp!, type: pokemonType, abilities: pokemonAbilities)
        }) else {
            fatalError("Detail View Controller not found.")
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func cellToBePassedTappedData(pokeURL: String) {
        // This is the actual network call which collects the data
        if let url = URL(string: pokeURL) {
            if let data = try? Data(contentsOf: url) {
                
                parsePokemonData(json: data)
            }
        }
    }
    
    func parsePokemonData(json: Data) {
        let decoder = JSONDecoder()
        
        // this is where I got stuck.  The data for the pokemon abilities and type is nested JSON and
        // i have never had to parse this before and I have run out of time, but i know that this is the
        // problem.
        
        if let jsonResults = try? decoder.decode(Abilities.self, from: json) {
            pokemonBaseExp = jsonResults.base_experience
            pokemonAbilities = jsonResults.abilities
            pokemonNumber = jsonResults.id
            
        }
                
        if let jsonResults = try? decoder.decode(Types.self, from: json) {
            
            pokemonType = jsonResults.types
            
        }
    }
}



