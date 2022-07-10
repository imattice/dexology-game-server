import Vapor

func routes(_ app: Application) throws {
    app.get("daily") { req -> String in
        let game = await GameManager.fetchGame(for: Date(), in: req.db)
        print("fecthed game \(String(describing: game))")
        do {
            let jsonData = try JSONEncoder().encode(game)
            guard let string = String(data: jsonData, encoding: .utf8) else {
                print("Failed to encode string from data")
                throw Abort(.internalServerError)
            }
            return string

        } catch {
            print("Failed to encode game object to string: \(error)")
            throw Abort(.internalServerError)
        }
    }

    app.get("clear") { req -> String in
        await DatabaseManager.clearData(in: req.db)
        
        return ""
    }

    app.patch("generate-data-source") { req -> String in
        do {
            try await req.fileio.writeFile(ByteBuffer(string: "Hello world"), at: "Public/data-source.json")
        } catch {
            print("failed to write to file: \(error)")
        }
        
        return ""
    }

//    app.get("generate-data-source") { req in
////        req.fileio.writeFile(ByteBuffer(string: "Hello, world"), at: "/path/to/file")
//
////        return req.eventLoop.makeSucceededVoidFuture()
//    }
}
