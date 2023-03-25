//
//  PokemonVC.swift
//  Pokedex
//
//  Created by Ekrem on 25.03.2023.
//

import UIKit

class PokemonViewController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var firstPowerLabel: UILabel!
    @IBOutlet weak var secondPowerLabel: UILabel!
    @IBOutlet weak var catchButton: UIButton!
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var pokemonDetails: UITextView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var contentView: UIView!

  
    public var url = ""
    private var isCaughtTapped = false
    private var pokemonResult: PokemonResult?
    private var pokemonDetailsResult: PokemonDetails?
    private let pokemonDetailsURL = "https://pokeapi.co/api/v2/pokemon-species/"


 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the contentView and start the progress bar
        contentView.isHidden = true
        loadingIndicator.startAnimating()

        loadPokemonInformation()
    }

  //   Funcs
    
    private func loadPokemonInformation() {
        guard let url = URL(string: url) else { return }

        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let `self` = self,
                  let data = data else {
                return
            }

            do {
                let result = try JSONDecoder().decode(PokemonResult.self, from: data)

                DispatchQueue.main.async {
                    self.pokemonResult = result

                    
                    self.handlePokemonResponse()
                    
                   
                    self.loadPokemonImage()
                }
            }
            catch let error {
                print(error)
            }

        }.resume()

    }

    
    private func handlePokemonResponse() {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self,
                  let pokemonResult = self.pokemonResult else {
                return
            }

            self.navigationItem.title = pokemonResult.name.uppercased()
            self.nameLabel.text = pokemonResult.name.uppercased()
            self.indexLabel.text = String(format: "#%03d", pokemonResult.id)
            self.isCaughtTapped = UserDefaults.standard.bool(forKey: pokemonResult.name.uppercased())

            let buttonTitle = self.isCaughtTapped ? "Release" : "Catch"
            self.catchButton.setTitle(buttonTitle, for: .normal)

            self.firstPowerLabel.text = pokemonResult.types.filter({ $0.slot == 1 }).first?.type.name
            self.secondPowerLabel.text = pokemonResult.types.filter({ $0.slot == 2
            }).first?.type.name
        }

        
        loadPokemonDetails()
    }

    
    private func loadPokemonImage() {
        guard let pokemonResult = self.pokemonResult,
              let imageURL = URL(string: pokemonResult.sprites.front_default) else {
            return
        }

        pokemonImage.load(url: imageURL)
    }

    
    private func loadPokemonDetails() {
        guard let pokemonResult = self.pokemonResult,
              let descriptionUrl = URL(string: "\(pokemonDetailsURL)\(pokemonResult.id)") else {
            return
        }

        URLSession.shared.dataTask(with: descriptionUrl) { [weak self] (data, response, error) in
            guard let `self` = self,
                  let data = data else {
                return
            }

            do {
                let details = try JSONDecoder().decode(PokemonDetails.self, from: data)
                DispatchQueue.main.async {
                    self.pokemonDetailsResult = details
                    self.handlePokemonDetailsResponse()
                }
            }
            catch let error {
                print(error)
            }
        }.resume()
    }

   
    private func handlePokemonDetailsResponse() {
        self.pokemonDetails.text = pokemonDetailsResult?.flavor_text_entries.first?.flavor_text

        self.loadingIndicator.stopAnimating()
        self.loadingIndicator.isHidden = true
        self.contentView.isHidden = false
    }


}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
