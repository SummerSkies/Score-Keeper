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
        //Kind of like viewDidLoad but for cells
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //If the user taps the cell, they see a visable confirmation of it
        super.setSelected(selected, animated: animated)
    }
    
    func update(with game: Game) {
        //Update the cell's labels to display its games's information
        gameIcon.image = game.icon
        gameTypeLabel.text = game.type
        
        guard let winner = game.winner else { return gameWinnerLabel.text = "No Winner Yet" } //If the game has no winner, set the winner label to "No Winner Yet"
        gameWinnerLabel.text = "Winner: \(winner.name)" //Otherwise, set the label to display the winner's name
    }
}
