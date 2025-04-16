//
//  FavoritesViewController.swift
//  CheersMix2
//
//  Created by Bezawit Zeleke on 4/15/25.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
   
    @IBOutlet weak var tableView: UITableView!
    
    var favoriteCocktails: [Cocktail] = []
    override func viewDidLoad() {
            super.viewDidLoad()
            title = "Favorites"
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: "CocktailTableViewCell", bundle: nil), forCellReuseIdentifier: "CocktailCell")
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearAllFavorites))
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            loadFavorites()
            tableView.reloadData()
        }

        func loadFavorites() {
            if let data = UserDefaults.standard.data(forKey: "favoriteCocktails"),
               let favorites = try? JSONDecoder().decode([Cocktail].self, from: data) {
                favoriteCocktails = favorites.sorted { $0.strDrink < $1.strDrink }
            } else {
                favoriteCocktails = []
            }
            updateEmptyState()
        }

        @objc func clearAllFavorites() {
            favoriteCocktails.removeAll()
            UserDefaults.standard.removeObject(forKey: "favoriteCocktails")
            tableView.reloadData()
            updateEmptyState()
        }

        func removeFavorite(at index: Int) {
            favoriteCocktails.remove(at: index)
            if let data = try? JSONEncoder().encode(favoriteCocktails) {
                UserDefaults.standard.set(data, forKey: "favoriteCocktails")
            }
            updateEmptyState()
        }

        func updateEmptyState() {
            if favoriteCocktails.isEmpty {
                let label = UILabel()
                label.text = "No favorites yet 🍹"
                label.textAlignment = .center
                label.textColor = .gray
                label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
                tableView.backgroundView = label
            } else {
                tableView.backgroundView = nil
            }
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return favoriteCocktails.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cocktail = favoriteCocktails[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "CocktailCell", for: indexPath) as! CocktailCell
            cell.configure(with: cocktail)
            return cell
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let cocktail = favoriteCocktails[indexPath.row]
            let storyboard = UIStoryboard(name: "Detail", bundle: nil)
            let detailVC = storyboard.instantiateViewController(withIdentifier: "CocktailDetailViewController") as! CocktailDetailViewController
            detailVC.cocktail = cocktail
            navigationController?.pushViewController(detailVC, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        }

        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                removeFavorite(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
