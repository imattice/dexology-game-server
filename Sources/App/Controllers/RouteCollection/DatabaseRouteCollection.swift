//
//  DatabaseRouteCollection.swift
//  
//
//  Created by Ike Mattice on 7/10/22.
//

import Foundation
import Vapor

struct DatabaseRouteCollection: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let collection = routes.grouped("database")
        collection.get("clear", use: clearDatabase)
    }

    func clearDatabase(with req: Request) async throws -> Response {
        await DatabaseManager.clearData(in: req.db)

        return Response(status: .ok)
    }
}
