//
//  Player.swift
//  Score Keeper
//
//  Created by Juliana Nielson on 3/24/23.
//

import Foundation
import UIKit

struct Player: Equatable {
    //Custom object Player; Equatable allows player type object to be compared to each other
    
    //Player properties:
    let id: UUID
    var profilePicture = UIImage(named: "Profile Placeholder Image") //App is not currently able to support custom images for each player; a placeholder image is provided for all players instead
    var name: String
    var score: Int
    
    init(name: String, score: Int) {
        self.id = UUID() //When creating a new player, give it a unique id; this id will allow for proper comparison between players
        self.name = name
        self.score = score
        //This init is created mostly for the purpose of unique ids, but it is required to include the properties name and score inside it. Anything not required is not included.
    }
    
    static func == (firstPlayer: Player, secondPlayer: Player) -> Bool {
        return firstPlayer.id == secondPlayer.id
        //Tells the system how to compare player objects: if their ids are the same, they are the same object.
    }
}
