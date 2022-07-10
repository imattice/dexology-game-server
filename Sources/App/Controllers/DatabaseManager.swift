//
//  DatabaseManager.swift
//  
//
//  Created by Ike Mattice on 6/25/22.
//

import Vapor
import Fluent
import FluentPostgresDriver

public enum DatabaseManager {
    private static let hostName: String = "localhost"
    private static let username: String = "vapor"
    private static let password: String = "vapor"
    private static let database: String = "vapor"

    public static func configure(for app: Application) {
        app.databases.use(.postgres(hostname: hostName, username: username, password: password, database: database), as: .psql)

        Task {
            await setUpSchema(for: app.db)
        }
    }

    public static func clearData(in database: Database) async {
        do {
            try await GameHistory.query(on: database).all().delete(on: database)
            try await database.schema(GameHistory.schema).delete()

            print("Database cleared!")
        } catch {
            print("failed to delete \(String(describing: GameHistory.self)) with error:\n\(error)")
        }
    }

    private static func setUpSchema(for database: Database) async {
        do {
        try await database.schema(GameHistory.schema)
            .ignoreExisting()
            .id()
            .field("index", .int, .required)
            .field("selected_date", .date, .required)
            .create()
        } catch {
            print("failed to create schema with error: \(error)")
        }
    }
}
