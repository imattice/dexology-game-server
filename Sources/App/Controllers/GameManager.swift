//
//  GameManager.swift
//  
//
//  Created by Ike Mattice on 6/23/22.
//

import Foundation
import Fluent

/// A group of functions that manage a game
public enum GameManager {
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
}
