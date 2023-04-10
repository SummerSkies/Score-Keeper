//
//  GameViewCell.swift
//  Score Keeper
//
//  Created by Juliana Nielson on 3/29/23.
//

import UIKit

class GameInfoCell: UITableViewCell {
    
    @IBOutlet weak var winnerImage: UIImageView!
    @IBOutlet weak var winnerName: UILabel!
    
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
        if let winner = game.winner {
            winnerImage.image = winner.profilePicture
            winnerName.text = winner.name
            //If the game has a winner, display their name and picture
        } else {
            winnerImage.image =  UIImage(systemName: "person.crop.circle.badge.questionmark")
            winnerName.text = "No Winner Yet"
            //Else, display default values
        }
    }
}
