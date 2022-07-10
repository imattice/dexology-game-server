import Vapor
import Queues
import QueuesRedisDriver
import FluentPostgresDriver

// configures your application
public func configure(_ app: Application) throws {
    Task {
        await DatabaseManager.configure(for: app)
    }

    try JobManager.setUp(for: app)

    // register routes
    try routes(app)
}
