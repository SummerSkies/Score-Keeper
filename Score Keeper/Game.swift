//
//  Games.swift
//  Score Keeper
//
//  Created by Juliana Nielson on 3/28/23.
//

import Foundation
import UIKit

struct Game: Equatable {
    //Custom object Game; Equatable allows game type object to be compared to each other
    
    //Game properties:
    let id: UUID
    var icon = UIImage(systemName: "dice.fill") //App is not currently able to support custom images for each game; a placeholder image is provided for all games instead
    var type: String
    var winner: Player? //Winner is optional because if there are no players in a game, there cannot be a winner
    var players: [Player]
    
    init(type: String, players: [Player]) {
        self.id = UUID() //When creating a new game, give it a unique id; this id will allow for proper comparison between games
        self.type = type
        self.players = players
        //This init is created mostly for the purpose of unique ids, but it is required to include the properties name and score inside it. Anything not required is not included.
    }
    
    mutating func updateWinner() {
        //Much like the delegate func updateScores, this func updates a game's current winner if the cell holding the game does not display the winner properly
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
    
    static func == (firstGame: Game, secondGame: Game) -> Bool {
        return firstGame.id == secondGame.id
        //Tells the system how to compare game objects: if their ids are the same, they are the same object.
    }
}
