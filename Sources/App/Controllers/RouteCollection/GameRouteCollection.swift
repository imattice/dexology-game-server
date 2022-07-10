//
//  GameRouteCollection.swift
//  
//
//  Created by Ike Mattice on 7/10/22.
//

import Foundation
import Vapor

struct GameRouteCollection: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let collection = routes.grouped("game")
        collection.get("daily", use: fetchDaily)
    }

    func fetchDaily(with req: Request) async throws -> GameHistory {
        guard let game = await GameManager.fetchGame(for: Date.now, in: req.db) else {
            throw Abort(.internalServerError)
        }
        print("fetched game \(String(describing: game))")
        return game
    }
}
