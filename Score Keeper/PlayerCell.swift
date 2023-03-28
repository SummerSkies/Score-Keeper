//
//  PlayerCell.swift
//  Score Keeper
//
//  Created by Juliana Nielson on 3/24/23.
//

import UIKit

class PlayerCell: UITableViewCell{

    @IBOutlet weak var playerProfilePicture: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var scoreStepper: UIStepper!
    @IBOutlet weak var playerScoreLabel: UILabel!
    
    var previousStepperValue = 0
    
    var labelChanged = false {
        didSet {
            for player in PlayerList.team {
                guard player.name == playerNameLabel.text else { continue }
                guard let indexOfExistingPlayer = PlayerList.team.firstIndex(of: player) else { continue }
                guard let currentScore = Int(playerScoreLabel.text ?? "0") else { continue }
                guard let tableView = superview as? UITableView, let playerList = tableView.delegate as? PlayerList else { continue }
                playerScoreLabel.text = String(currentScore)
                PlayerList.team[indexOfExistingPlayer].score = currentScore
                PlayerList.team.sort { $0.score > $1.score }
                playerList.tableView.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func update(with player: Player){
        playerProfilePicture.image = player.profilePicture
        playerNameLabel.text = player.name
        playerScoreLabel.text = String(player.score)
    }

    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        let currentScore = Int(playerScoreLabel.text!)!
        
        if scoreStepper.value > Double(previousStepperValue) {
            scoreStepper.value = Double(currentScore) + scoreStepper.stepValue
            playerScoreLabel.text = String(Int(scoreStepper.value))
        } else {
            scoreStepper.value = Double(currentScore) - scoreStepper.stepValue
            playerScoreLabel.text = String(Int(scoreStepper.value))
        }
        previousStepperValue = Int(scoreStepper.value)
        labelChanged.toggle()
   }
}
