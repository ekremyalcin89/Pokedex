//
//  NameCell.swift
//  Pokedex
//
//  Created by Ekrem on 24.03.2023.
//


import UIKit

class NameCell: UITableViewCell {
    
    var aSprite: Sprite?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sprite: UIImageView!
    
    // Stops images changing in view.  Not perfect but it stops the wrong image being displayed.
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = ""
        sprite.image = nil
    }
    
    func networkCall(imageURL: String) {
        DispatchQueue.global(qos: .userInitiated).async { [self] in
            if let url = URL(string: imageURL) {
                if let data = try? Data(contentsOf: url) {
                    parseImageJSON(json: data)
                }
            }
        }
    }
    
    func fetchImage(urlString: String) {
        // Get data
        guard let url = URL(string: urlString) else {
            fatalError("Could not load urlString")
        }
        
        // Convert data to image
        let getDataTask = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            // Makes it run on the background thread to that the app dosent stutter when scrolling
            DispatchQueue.main.async {
                let imageData = UIImage(data: data)!
                self.sprite.image = imageData
            }
        }
        getDataTask.resume()
    }
    
    func parseImageJSON(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonResults = try? decoder.decode(PokemonDetails.self, from: json) {
            aSprite = jsonResults.sprites
            fetchImage(urlString: (aSprite?.front_default)!)
        }
    }
}
