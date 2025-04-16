//
//  CocktailViewController.swift
//  CheersMix2
//
//  Created by Bezawit Zeleke on 4/14/25.
//

import UIKit
import NukeExtensions

class CocktailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    
    private var cocktails: [Cocktail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cocktails"
        tableView.delegate = self
        tableView.dataSource = self
        fetchCocktails()
    }
    
    // MARK: - TableView Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cocktails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cocktail = cocktails[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CocktailCell", for: indexPath) as! CocktailCell
        cell.cocktailName.text = cocktail.strDrink
        if let url = URL(string: cocktail.strDrinkThumb) {
            NukeExtensions.loadImage(with: url, into: cell.cocktailImage)
        }
        return cell
    }
    
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cocktail = cocktails[indexPath.row]
        let storyboard = UIStoryboard(name: "Detail", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "CocktailDetailViewController") as! CocktailDetailViewController
        detailVC.cocktail = cocktail
        navigationController?.pushViewController(detailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Segue Preparation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCocktailDetail",
           let destinationVC = segue.destination as? CocktailDetailViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            let selectedCocktail = cocktails[indexPath.row]
            destinationVC.cocktail = selectedCocktail
        }
    }
    
    // MARK: - Networking with Retry
    
    func fetchCocktails(retryCount: Int = 3) {
        let url = URL(string: "https://thecocktaildb.com/api/json/v1/1/search.php?s=mojito")!
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 60// seconds
        let session = URLSession(configuration: config)
        
        session.dataTask(with: url) { data, response, error in
            if let error = error as? URLError, error.code == .networkConnectionLost, retryCount > 0 {
                print("⚠️ Connection lost. Retrying... (\(retryCount - 1) tries left)")
                DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
                    self.fetchCocktails(retryCount: retryCount - 1)
                }
                return
            }
            
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("❌ No data")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(CocktailResponse.self, from: data)
                print("✅ Cocktails fetched: \(String(describing: response.drinks?.count))")
                DispatchQueue.main.async {
                    self.cocktails = response.drinks ?? []
                    self.tableView.reloadData()
                }
            } catch {
                print("❌ JSON decoding error: \(error)")
            }
        }.resume()
    }
}
