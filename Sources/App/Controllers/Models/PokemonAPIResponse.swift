//
//  PokemonAPIResponse.swift
//  
//
//  Created by Ike Mattice on 7/11/22.
//

import Foundation

struct PokemonAPIResponse: Decodable {
    let id: Int
    let name: String
    let height: Double
    let weight: Double
    let spriteUrlString: String
    let artworkUrlString: String
    let primaryType: String
    let secondaryType: String?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let index = try container.decode(Int.self, forKey: .id)
        self.id = index
        self.name = try container.decode(String.self, forKey: .name)
        self.height = try container.decode(Double.self, forKey: .height) * 10
        self.weight = try container.decode(Double.self, forKey: .weight) * 100

        let spriteContainer = try container.nestedContainer(keyedBy: SpriteKey.self, forKey: .sprites)
        self.spriteUrlString = try spriteContainer.decode(String.self, forKey: .front_default)
        self.artworkUrlString = try spriteContainer.nestedContainer(keyedBy: SpriteKey.self, forKey: .other)
            .nestedContainer(keyedBy: SpriteKey.self, forKey: .officialArtwork)
            .decode(String.self, forKey: .front_default)

        var typeContainer = try container.nestedUnkeyedContainer(forKey: .types)
        //.nestedContainer(keyedBy: TypeKey.self, forKey: .types)
        var types: [String] = [String]()
        while !typeContainer.isAtEnd {
            let type = try typeContainer.nestedContainer(keyedBy: TypeKey.self)
                .nestedContainer(keyedBy: TypeKey.self, forKey: .type)
                .decode(String.self, forKey: .name)
            types.append(type)
        }
        guard let primaryType = types.first else {
            // TODO: fix this
            fatalError()
        }
        self.primaryType = primaryType
        self.secondaryType = types.count > 1 ? types.last : nil
    }

    enum TypeKey: String, CodingKey {
        case zero = "0", one = "1", type, name
    }

    enum CodingKeys: String, CodingKey {
        case id, name, height, weight, sprites, types
    }
    enum SpriteKey: String, CodingKey {
        case front_default, other, officialArtwork = "official-artwork"
    }

    var generation: Int {
        switch id {
        case 1...151:
            return 1
        case 152...251:
            return 2
        case 252...386:
            return 3
        case 387...493:
            return 4
        case 494...649:
            return 5
        case 650...721:
            return 6
        case 722...809:
            return 7
        case 810...905:
            return 8
        default:
            print("failed to create generation from index \(id)")
            return 0
        }
    }
}
