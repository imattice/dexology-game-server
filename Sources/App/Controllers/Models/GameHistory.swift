//
//  GameHistory.swift
//  
//
//  Created by Ike Mattice on 6/23/22.
//

import Foundation
import FluentPostgresDriver
import Vapor

final class GameHistory: Model, Content, AsyncResponseEncodable {
    // Name of the table or collection.
    static let schema = "game_histories"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "index")
    var index: Int
    @Field(key: "selected_date")
    var selectedDate: String

    static var dateFormatter: DateFormatter {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateStyle = .short

        return formatter
    }

    init() { }

    // Creates a new Galaxy with all properties set.
    init(id: UUID? = nil, index: Int, selectedDate: Date = Date()) {
        self.id = id
        self.index = index
        self.selectedDate = GameHistory.dateFormatter.string(from: selectedDate)
    }
}
