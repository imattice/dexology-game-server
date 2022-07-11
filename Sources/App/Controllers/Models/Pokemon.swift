//
//  Pokemon.swift
//  
//
//  Created by Ike Mattice on 7/10/22.
//

import Foundation
import FluentPostgresDriver
import Vapor

struct Pokemon: Codable {
    let id: Int
    let name: String
    let height: Double
    let weight: Double
    let imagePath: ImagePath
    let type: PokemonType

    init(response: PokemonAPIResponse) {
        self.id = response.id
        self.name = response.name
        self.height = response.height
        self.weight = response.weight
        self.imagePath = ImagePath(sprite: response.spriteUrlString, artwork: response.artworkUrlString)
        self.type = PokemonType(primary: response.primaryType, secondary: response.secondaryType)
    }
}

struct ImagePath: Codable {
    let sprite: String
    let artwork: String
}

struct PokemonType: Codable {
    let primary: String
    let secondary: String?
}
