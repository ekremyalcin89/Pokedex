//
//  pokeModel.swift
//  Pokedex
//
//  Created by Ekrem on 25.03.2023.
//

import Foundation

struct PokemonListResults: Codable {
    let results: [PokemonListResult]
}

struct PokemonListResult: Codable {
    let name: String
    let url: String
}

struct PokemonResult: Codable {
    let id: Int
    let name: String
    let types: [PokemonTypeEntry]
    let sprites: PokemonSprites
}

struct PokemonTypeEntry: Codable {
    let slot: Int
    let type: PokemonType
}

struct PokemonType: Codable {
    let name: String
}

struct PokemonSprites: Codable {
    let front_default: String
}

struct PokemonDetails: Codable {
    let flavor_text_entries: [PokemonDetailEntry]
}

struct PokemonDetailEntry: Codable {
    let flavor_text: String
}
