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
        collection.get("data-source", use: fetchDataSource)
        collection.get("update-data-source", use: updateDataSource)
    }

    func fetchDaily(with request: Request) async throws -> GameHistory {
        guard let game = await GameManager.fetchGame(for: Date.now, in: request.db) else {
            throw Abort(.internalServerError)
        }
        print("fetched game \(String(describing: game))")
        return game
    }

    func fetchDataSource(with request: Request) async throws -> Response {
        let responseHeaders = [
            ("", "")
        ]
        let buffer = try await GameManager.readDataSource(with: request)

        return Response(status: .ok,
                 version: .http3,
                 headers: HTTPHeaders(responseHeaders),
                 body: Response.Body(buffer: buffer))
    }

    func updateDataSource(with request: Request) async throws -> Response {
        await GameManager.updateDataSource(with: request)

        return Response(status: .ok)
    }
}
