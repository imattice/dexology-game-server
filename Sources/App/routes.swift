import Vapor

func routes(_ app: Application) throws {
    app.get("routes") { req -> String in
        return app.routes.all.debugDescription
    }

    try app.register(collection: DatabaseRouteCollection())
    try app.register(collection: GameRouteCollection())
}
