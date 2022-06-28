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
}
