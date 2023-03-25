//
//  PokemonVC.swift
//  Pokedex
//
//  Created by Ekrem on 23.03.2023.
//

import UIKit

class PokemonInfoController: UIViewController {
    
   
    
    var pokemon: Pokemon? {
        didSet {
            navigationItem.title = pokemon?.name?.capitalized
            imageView.image = pokemon?.image
            infoLabel.text = pokemon?.description
            infoView.pokemon = pokemon
            
            if let evoArray = pokemon?.evoArray {
                if evoArray.count > 1 {
                    firstEvoImageView.image = evoArray[0].image
                    secondEvoImageView.image = evoArray[1].image
                } else {
                    firstEvoImageView.image = evoArray[0].image
                }
            }
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    let infoView: PokeInfoView = {
        let view = PokeInfoView()
        view.configureViewForInfoController()
        return view
    }()
    
    lazy var evolutionView: UIView = {
        let view = UIView()
        view.backgroundColor = .PokeRed()
        
        view.addSubview(evoLabel)
        evoLabel.translatesAutoresizingMaskIntoConstraints = false
        evoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        evoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        return view
    }()
    
    let evoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Evolution Chain"
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    let firstEvoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let secondEvoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewComponents()
    }
    
    
    //   Configures
    func configureViewComponents() {
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .white
        
        view.addSubview(imageView)
        imageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 44, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        
        view.addSubview(infoLabel)
        infoLabel.anchor(top: nil, left: imageView.rightAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 44, paddingLeft: 16, paddingBottom: 0, paddingRight: 4, width: 0, height: 0)
        infoLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
        view.addSubview(infoView)
        infoView.anchor(top: infoLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)
        
        view.addSubview(evolutionView)
        evolutionView.anchor(top: infoView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        view.addSubview(firstEvoImageView)
        firstEvoImageView.anchor(top: evolutionView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 32, paddingBottom: 0, paddingRight: 0, width: 120, height: 120)
        
        view.addSubview(secondEvoImageView)
        secondEvoImageView.anchor(top: evolutionView.bottomAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 32, width: 120, height: 120)
    }
}
