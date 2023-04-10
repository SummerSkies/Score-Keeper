//
//  PlayerCell.swift
//  Score Keeper
//
//  Created by Juliana Nielson on 3/24/23.
//

import UIKit

protocol PlayerCellDelegate: AnyObject {
    func updateScores(cell: PlayerCell)
    //Updates the cell's player score if it does not match its label
}

class PlayerCell: UITableViewCell {

    @IBOutlet weak var playerProfilePicture: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var scoreStepper: UIStepper!
    @IBOutlet weak var playerScoreLabel: UILabel!
    
    weak var delegate: PlayerCellDelegate? //Allows connection from this class to another class via the delegate; set to weak to avoid a strong reference cycle, or retain cycle
    
    var previousStepperValue = 0 //Used in stepperValueChanged
    
    override func prepareForReuse() {
        //Allows cell delegate to function properly
        super.prepareForReuse()
        self.delegate = nil
    }
    
    override func awakeFromNib() {
        //Kind of like viewDidLoad but for cells
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //If the user taps the cell, they see a visable confirmation of it
        super.setSelected(selected, animated: animated)
    }
    
    func update(with player: Player) {
        //Update the cell's labels to display its player's information
        playerProfilePicture.image = player.profilePicture
        playerNameLabel.text = player.name
        playerScoreLabel.text = String(player.score)
    }

    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        //Caluclates how the cell's score label will change based on its stepper's actions
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
        self.delegate?.updateScores(cell: self) //Delegate call
   }
}
