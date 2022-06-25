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
    }
}
