//
//  PlayerCell.swift
//  Score Keeper
//
//  Created by Juliana Nielson on 3/24/23.
//

import UIKit

protocol PlayerCellDelegate: AnyObject {
    func updateScores(cell: PlayerCell)
}

class PlayerCell: UITableViewCell{

    @IBOutlet weak var playerProfilePicture: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var scoreStepper: UIStepper!
    @IBOutlet weak var playerScoreLabel: UILabel!
    
    weak var delegate: PlayerCellDelegate?
    
    var previousStepperValue = 0
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.delegate = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func update(with player: Player) {
        playerProfilePicture.image = player.profilePicture
        playerNameLabel.text = player.name
        playerScoreLabel.text = String(player.score)
    }

    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        guard let playerScore = playerScoreLabel.text else { return playerScoreLabel.text = "0" }
        guard let currentScore = Int(playerScore) else { return playerScoreLabel.text = "0" }
        
        if scoreStepper.value > Double(previousStepperValue) {
            scoreStepper.value = Double(currentScore) + scoreStepper.stepValue
            playerScoreLabel.text = String(Int(scoreStepper.value))
        } else {
            scoreStepper.value = Double(currentScore) - scoreStepper.stepValue
            playerScoreLabel.text = String(Int(scoreStepper.value))
        }
        previousStepperValue = Int(scoreStepper.value)
        self.delegate?.updateScores(cell: self)
   }
}
