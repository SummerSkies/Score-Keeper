//
//  Player.swift
//  Score Keeper
//
//  Created by Juliana Nielson on 3/24/23.
//

import Foundation
import UIKit

struct Player: Equatable {
    let id: UUID
    var profilePicture = UIImage(named: "Profile Placeholder Image")
    var name: String
    var score: Int
    
    init(name: String, score: Int) {
        self.id = UUID()
        self.name = name
        self.score = score
    }
    
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.id == rhs.id
    }
}
