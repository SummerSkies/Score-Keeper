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
        winnerImage.image = game.winner.profilePicture
        winnerName.text = game.winner.name
    }

}
