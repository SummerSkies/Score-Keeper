//
//  Games.swift
//  Score Keeper
//
//  Created by Juliana Nielson on 3/28/23.
//

import Foundation
import UIKit

struct Game {
    var icon = UIImage(systemName: "dice.fill")
    var type: String
    var winner: Player
    var players: [Player]
}
