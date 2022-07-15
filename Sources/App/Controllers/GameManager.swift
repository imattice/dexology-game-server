//
//  GameManager.swift
//  
//
//  Created by Ike Mattice on 6/23/22.
//

import Foundation
import Fluent
import Vapor

/// A group of functions that manage a game
public enum GameManager {
    private static let dataSourceFilePath: String = "Public/data-source.json"

    /// Fetches all history objects and returns the object that matches the given date
    /// - Parameters:
    ///   - date: the date to be matched
    ///   - database: the data base to fetch the histories from
    /// - Returns: the specific history that matches the given date
    static func fetchGame(for date: Date, in database: Database) async -> GameHistory? {
        do {
            let dateString = GameHistory.dateFormatter.string(from: date)
            let histories = GameHistory.query(on: database)
            let all = try await histories.all()
            return all.first(where: {
                $0.selectedDate == dateString
            })
        } catch {
            print("No game for date: \(date)")
            return nil
        }
    }

    /// Fetches all history from the database
    /// - Parameter database: The database to fetch history
    /// - Returns: The fetched history
    static func fetchHistory(in database: Database) async -> [GameHistory] {
        do {
            return try await GameHistory.query(on: database).sort(\.$selectedDate).all().get()
        } catch {
            print("Error in fetching database: \(error)")
            return [GameHistory]()
        }
    }

    /// Generates the daily index used as the primary component of the hidden Pokemon
    /// - Parameter database: The database in which to store the index
    public static func generateDaily(on database: Database) async {
        let histories = await fetchHistory(in: database)
        var bufferSize: Int {
            histories.count >= Configuration.bufferSize ? Configuration.bufferSize : histories.count
        }
        let buffer = histories.isEmpty ? [Int]() : histories[0...bufferSize - 1].map { $0.index }
        let index = selectIndex(excludingElementsIn: buffer)
        let game = GameHistory(index: index)

        do {
            // TODO: Remove this clear on release
            if try await GameHistory.query(on: database).count() > 5 { await DatabaseManager.clearData(in: database) }

            _ = try await game.create(on: database)
        } catch {
            print("failed to create game with error: \(game)")
        }

        print("history count: \(await GameManager.fetchHistory(in: database).count)")
    }

    /// Selects a random index
    /// - Returns: the selected  index
    private static func selectIndex(excludingElementsIn indexBuffer: [Int]) -> Int {
        let index = Int.random(in: 1...Configuration.maxIndex)

        if indexBuffer.contains(index) {
            return selectIndex(excludingElementsIn: indexBuffer)
        } else {
            return index
        }
    }

    public static func updateDataSource(with request: Request) async {
        let dataSource = await fetchDataSource()

        await save(dataSource: dataSource, with: request)
    }

    private static func fetchDataSource() async -> [Pokemon] {
        let endpoint = "https://pokeapi.co/api/v2/pokemon/"
        var dataSource = [Pokemon]()

        for id in 1...Configuration.maxIndex + 1 {
            guard let url = URL(string: endpoint + "\(id)") else {
                // TODO: Handle error
                print("failed to generate url from \(endpoint + "\(id)")")
                continue
            }
            let request = URLRequest(url: url)

            do {
                let (data, _): (Data, URLResponse) = try await URLSession.shared.data(for: request)
                // TODO: Handle response
                let pokemon = try JSONDecoder().decode(PokemonAPIResponse.self, from: data)

                dataSource.append(Pokemon(response: pokemon))
            } catch {
                // TODO: Handle error
                print("failed to decode pokemon data with error: \(error)")
                return [Pokemon]()
            }
        }
        
        dump(dataSource)

        return dataSource
    }

    private static func convert(dataSource: [Pokemon]) -> String? {
        do {
            let encoded = try JSONEncoder().encode(dataSource)
            return String(data: encoded, encoding: .utf8)
        } catch {
            // TODO: Handle error
            print("could not convert data source to string")
            return nil
        }
    }

    private static func save(dataSource: [Pokemon], with request: Request) async {
        guard let stringData: String = convert(dataSource: dataSource) else {
            // TODO: Handle error

            return
        }

        do {
            try await request.fileio.writeFile(ByteBuffer(string: stringData), at: GameManager.dataSourceFilePath)

        } catch {
            print("failed to write to file: \(error)")

            // TODO: Handle error
        }
    }

    static func readDataSource(with request: Request) async throws -> ByteBuffer {
        do {
            return try await request.fileio.collectFile(at: GameManager.dataSourceFilePath)
        } catch {
            // TODO: Handle Error
            throw Abort(.internalServerError)
        }
    }
}
