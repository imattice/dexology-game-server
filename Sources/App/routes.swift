import Vapor

func routes(_ app: Application) throws {
    app.get("routes") { req -> String in
        return app.routes.all.debugDescription
    }

    try app.register(collection: DatabaseRouteCollection())
    try app.register(collection: GameRouteCollection())

    app.patch("generate-data-source") { req -> String in
        let filePath: String = "Public/data-source.json"
        do {
            try await req.fileio.writeFile(ByteBuffer(string: "Hello world"), at: filePath)
//            try await req.fileio.readFile(at: filePath) { chunk in
//                print(chunk)
//            }
        } catch {
            print("failed to write to file: \(error)")
        }
        
        return ""
    }
}
