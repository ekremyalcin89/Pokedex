//
//  CollectionViewCell.swift
//  Pokedex
//
//  Created by Ekrem on 23.03.2023.
//

import UIKit

protocol PokedexCellDelegate {
    func presentInfoView(withPokemon pokemon: Pokemon)
}

class PokedexCell: UICollectionViewCell {
    
    // Properties
    
    var delegate: PokedexCellDelegate?
    
    var pokemon: Pokemon? {
        didSet {
            nameLbl.text = pokemon?.name
            imageView.image = pokemon?.image
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .groupTableViewBackground
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var nameContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .PokeRed()
        
        view.addSubview(nameLbl)
        nameLbl.center(inView: view)
        return view
        
    }()
    
    let nameLbl: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Pikachu"
        return label
    }()
    
    // Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
      
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        
    
}
