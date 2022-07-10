//
//  GameHistoryMigration.swift
//  
//
//  Created by Ike Mattice on 7/10/22.
//

import Foundation
import FluentKit

struct GameHistoryMigration: AsyncMigration {
    func prepare(on database: Database) async throws {
        return try await database.schema(GameHistory.schema)
            .id()
            .field("index", .int, .required)
            .field("selected_date", .string, .required)
            .create()
    }

    func revert(on database: Database) async throws {
        return try await database.schema(GameHistory.schema).delete()
    }
}
