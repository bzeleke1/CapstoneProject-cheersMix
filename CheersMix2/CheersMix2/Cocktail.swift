//
//  Cocktail.swift
//  CheersMix2
//
//  Created by Bezawit Zeleke on 4/15/25.
//

import Foundation

enum AlcoholType: String, Codable {
    case alcoholic = "Alcoholic"
    case nonAlcoholic = "Non alcoholic"
    case optionalAlcohol = "Optional alcohol"
}

struct CocktailResponse: Codable {
    let drinks: [Cocktail]?
}

struct Cocktail: Codable {
    let idDrink: String
    let strDrink: String
    let strInstructions: String
    let strDrinkThumb: String
    let strAlcoholic: AlcoholType
}
