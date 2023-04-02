//
//  Games.swift
//  Score Keeper
//
//  Created by Juliana Nielson on 3/28/23.
//

import Foundation
import UIKit

struct Game: Equatable {
    
    let id: UUID
    var icon = UIImage(systemName: "dice.fill")
    var type: String
    var winner: Player?
    var players: [Player]
    
    init(type: String, players: [Player]) {
        self.id = UUID()
        self.type = type
        self.players = players
    }
    
    mutating func updateWinner() {
        var winnerScore = 0
        var winnerindex = 0
        for (index, player) in players.enumerated() {
            if player.score > winnerScore {
                winnerScore = player.score
                winnerindex = index
            }
        }
        winner = players[winnerindex]
    }
    
    static func == (lhs: Game, rhs: Game) -> Bool {
        return lhs.id == rhs.id
    }
}
