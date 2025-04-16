//
//  CocktailCell.swift
//  CheersMix2
//
//  Created by Bezawit Zeleke on 4/15/25.
//

import UIKit
import NukeExtensions
import NukeUI

class CocktailCell: UITableViewCell {
    
    @IBOutlet weak var cocktailImage: UIImageView!
    
    @IBOutlet weak var cocktailName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cocktailImage.layer.cornerRadius = 8
        cocktailImage.clipsToBounds = true
        cocktailImage.contentMode = .scaleAspectFill
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cocktailImage.image = UIImage(named: "placeholder")
    }
    
    func configure(with cocktail: Cocktail) {
        cocktailName.text = cocktail.strDrink
        
        if let url = URL(string: cocktail.strDrinkThumb) {
            // Use the shared pipeline to load the image
            NukeExtensions.loadImage(
                with: ImageRequest(url: url),
                options: ImageLoadingOptions(transition: .fadeIn(duration: 0.3)),
                into: cocktailImage
            )
        }
        
        
    }
}

