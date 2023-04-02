//
//  GameCell.swift
//  Score Keeper
//
//  Created by Juliana Nielson on 3/28/23.
//

import UIKit

class GameCell: UITableViewCell {

    @IBOutlet weak var gameIcon: UIImageView!
    @IBOutlet weak var gameTypeLabel: UILabel!
    @IBOutlet weak var gameWinnerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func update(with game: Game) {
        gameIcon.image = game.icon
        gameTypeLabel.text = game.type
        
        guard let winner = game.winner else { return gameWinnerLabel.text = "No Winner Yet" }
        gameWinnerLabel.text = "Winner: \(winner.name)"
    }
}
