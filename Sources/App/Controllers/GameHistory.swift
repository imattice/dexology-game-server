//
//  GameHistory.swift
//  
//
//  Created by Ike Mattice on 6/23/22.
//

import Foundation
//import Fluent
import FluentPostgresDriver

final class GameHistory: Model {
    // Name of the table or collection.
    static let schema = "game_histories"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "index")
    var index: Int
    @Field(key: "selected_date")
    var selectedDate: Date

    init() { }

    // Creates a new Galaxy with all properties set.
    init(id: UUID? = nil, index: Int, selectedDate: Date = Date()) {
        self.id = id
        self.index = index
        self.selectedDate = selectedDate
    }
}
