//
//  GameManager.swift
//  
//
//  Created by Ike Mattice on 6/23/22.
//

import Foundation

public enum GameManager {
    private static var indexBuffer: [Int] = []
    private static var gameHistory: [GameHistory] = []

    /// Generates a new game for the current day
    public static func generateDaily() {
        let index = selectIndex()
        let game = GameHistory(index: index, selectedDate: Date())

        gameHistory.append(game)
    }

    /// Selects a random index
    /// - Returns: the selected  index
    private static func selectIndex() -> Int {
        let index = Int.random(in: 1...Configuration.maxIndex)

        if indexBuffer.contains(index) {
            return selectIndex()
        }
        else {
            addToBuffer(index)
            return index
        }
    }

    /// Adds the provided index to the buffer
    /// - Parameter index: the index to add
    private static func addToBuffer(_ index: Int) {
        if indexBuffer.count == Configuration.bufferSize {
            indexBuffer.removeFirst()
        }
        indexBuffer.append(index)
    }
}
