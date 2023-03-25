//
//  ViewController.swift
//  Pokedex
//
//  Created by Ekrem on 23.03.2023.
//

import UIKit

private let reuseIdentifier = "PokedexCell"

class PokedexController: UICollectionViewController {
    
 
    
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var inSearchMode = false
    var searchBar: UISearchBar!
    
    let infoView: PokeInfoView = {
        let view = PokeInfoView()
        view.layer.cornerRadius = 5
        return view
    }()
    
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        return view
    }()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewComponents()
        fetchPokemon()
        
    }
    
 
    
    @objc func showSearchBar() {
        configureSearchBar(shouldShow: true)
    }
    
    @objc func handleDismissal() {
        dismissInfoView(pokemon: nil)
    }
    
    // API Here
    
    func fetchPokemon() {
        Service.instance.fetchPokemon { (pokemon) in
            DispatchQueue.main.async {
                self.pokemon = pokemon
                self.collectionView.reloadData()
            }
        }
    }
  
    
    func configureSearchBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    func configureSearchBar(shouldShow: Bool) {
        
        if shouldShow {
            
            searchBar = UISearchBar()
            searchBar.delegate = self
            searchBar.sizeToFit()
            searchBar.showsCancelButton = true
            searchBar.becomeFirstResponder()
            searchBar.tintColor = .white
            
            navigationItem.rightBarButtonItem = nil
            navigationItem.titleView = searchBar
            
        } else {
            
            navigationItem.titleView = nil
            configureSearchBarButton()
            inSearchMode = false
            collectionView.reloadData()
            
        }

    }
    
    func dismissInfoView(pokemon: Pokemon?) {
        UIView.animate(withDuration: 0.5, animations:  {
            self.visualEffectView.alpha = 0
            self.infoView.alpha = 0
            self.infoView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (_) in
            self.infoView.removeFromSuperview()
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            guard let pokemon = pokemon else { return }
          
            
        }
    }
    
    func configureViewComponents() {
        collectionView.backgroundColor = .white
        
        navigationController?.navigationBar.barTintColor = .PokeRed()
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.title = "Pokedex"
        
        configureSearchBarButton()
        
        collectionView.register(PokedexCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        view.addSubview(visualEffectView)
        visualEffectView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        visualEffectView.alpha = 0
        
        
        
    }
    
}


// SearchBarDelegate
extension PokedexController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        configureSearchBar(shouldShow: false)

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" || searchBar.text == nil {
            inSearchMode = false
            collectionView.reloadData()
            view.endEditing(true)
        } else {
            inSearchMode = true
            filteredPokemon = pokemon.filter({ $0.name?.range(of: searchText.lowercased()) != nil })
            collectionView.reloadData()
        }
        
    }
    
    
}

extension PokedexController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inSearchMode ? filteredPokemon.count : pokemon.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PokedexCell
        cell.pokemon = inSearchMode ? filteredPokemon[indexPath.row] : pokemon[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var pokemonEvoArray = [Pokemon]()
        
        let poke = inSearchMode ? filteredPokemon[indexPath.row] : pokemon[indexPath.row]
        
        if let evoChain = poke.evolutionChain {
            
            let evolutionChain = EvolutionChain(evolutionArray: evoChain)
            let evoIds = evolutionChain.evolutionIds
            
            evoIds.forEach { (id) in
                pokemonEvoArray.append(pokemon[id - 1])
            }
            
            poke.evoArray = pokemonEvoArray
            
        }

    }
}

extension PokedexController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 32, left: 8, bottom: 8, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 36) / 3
        return CGSize(width: width, height: width)
        
    }
    
}

extension PokedexController: PokedexCellDelegate {
    func presentInfoView(withPokemon pokemon: Pokemon) {
        
        configureSearchBar(shouldShow: false)
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        view.addSubview(infoView)
        infoView.configureViewComponents()
        infoView.delegate = self
        infoView.pokemon = pokemon
        infoView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.frame.width - 64, height: 350)
        infoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        infoView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -44).isActive = true
        
        // Animation
        
        infoView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        infoView.alpha = 0
        
        UIView.animate(withDuration: 0.5) {
            self.visualEffectView.alpha = 1
            self.infoView.alpha = 1
            self.infoView.transform = .identity
        }
        
    }
    
}

extension PokedexController: infoViewDelegate {
    func dismissInfoView(withPokemon pokemon: Pokemon?) {
        dismissInfoView(pokemon: pokemon)
    }
}
