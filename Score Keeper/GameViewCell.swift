//
//  GameViewCell.swift
//  Score Keeper
//
//  Created by Juliana Nielson on 3/29/23.
//

import UIKit

class GameViewCell: UITableViewCell {
    
    @IBOutlet weak var winnerImage: UIImageView!
    @IBOutlet weak var winnerName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func update(with game: Game) {
        if let winner = game.winner {
            winnerImage.image = winner.profilePicture
            winnerName.text = winner.name
        } else {
            winnerImage.image =  UIImage(systemName: "person.crop.circle.badge.questionmark")
            winnerName.text = "No Winner Yet"
        }
    }

}
