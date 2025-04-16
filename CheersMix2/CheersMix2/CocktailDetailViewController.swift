//
//  CocktailDetailViewController.swift
//  CheersMix2
//
//  Created by Bezawit Zeleke on 4/15/25.
//

import UIKit
import NukeExtensions

class CocktailDetailViewController: UIViewController {
    
    @IBOutlet weak var backdropImageView: UIImageView!
    
    @IBOutlet weak var cocktailNameLabel: UILabel!
    
    @IBOutlet weak var instructionTextView: UITextView!

    @IBOutlet weak var alcoholTypeLabel: UILabel!
    
    var cocktail: Cocktail?
        var isFavorited = false

        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
            title = cocktail?.strDrink
            setupUI()
            checkIfFavorited()
            setupFavoriteButton()
        }

        private func setupUI() {
            cocktailNameLabel.text = cocktail?.strDrink
            instructionTextView.text = cocktail?.strInstructions
            alcoholTypeLabel.text = "Type: \(cocktail?.strAlcoholic.rawValue ?? "Unknown")"

            if let urlString = cocktail?.strDrinkThumb,
               let url = URL(string: urlString) {
                NukeExtensions.loadImage(with: url, into: backdropImageView)
            }
        }

        private func setupFavoriteButton() {
            let heartImage = UIImage(systemName: isFavorited ? "heart.fill" : "heart")
            let favoriteButton = UIBarButtonItem(image: heartImage, style: .plain, target: self, action: #selector(toggleFavorite))
            navigationItem.rightBarButtonItem = favoriteButton
        }

        private func checkIfFavorited() {
            guard let cocktail = cocktail else { return }

            if let data = UserDefaults.standard.data(forKey: "favoriteCocktails"),
               let saved = try? JSONDecoder().decode([Cocktail].self, from: data) {
                isFavorited = saved.contains { $0.idDrink == cocktail.idDrink }
            }
        }

        @objc private func toggleFavorite() {
            guard let cocktail = cocktail else { return }

            var favorites: [Cocktail] = []
            if let data = UserDefaults.standard.data(forKey: "favoriteCocktails"),
               let saved = try? JSONDecoder().decode([Cocktail].self, from: data) {
                favorites = saved
            }

            if isFavorited {
                favorites.removeAll { $0.idDrink == cocktail.idDrink }
            } else {
                favorites.append(cocktail)
            }

            if let data = try? JSONEncoder().encode(favorites) {
                UserDefaults.standard.set(data, forKey: "favoriteCocktails")
            }

            isFavorited.toggle()
            setupFavoriteButton()
        }
    }
