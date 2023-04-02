//
//  DetailView.swift
//  Score Keeper
//
//  Created by Juliana Nielson on 3/27/23.
//

import UIKit
import Foundation

class PlayerDetails: UIViewController {
    
    @IBOutlet weak var playerNameTextField: UITextField!
    @IBOutlet weak var playerScoreTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var player: Player?
    let nonDidgitPattern = "[^0-9]"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerScoreTextField.keyboardType = .numberPad
        
        if let player = player {
            //If editing an existing player
            navigationItem.title = "Edit Player"
            playerNameTextField.text = player.name
            playerScoreTextField.text = String(player.score)
        } else {
            //If creating a new player
            navigationItem.title = "New Player"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        //Used to pass info to the GamePlayerList controller
        
        guard segue.identifier == "Save Player Unwind" else { return }
        
        let name = playerNameTextField.text!
        let score = Int(playerScoreTextField.text ?? "") ?? 0
        //info to pass
        
        if player != nil {
            player?.name = name
            player?.score = score
            //If player exists, update values
        } else {
            player = Player(name: name, score: score)
            //Else, create new player with provided values
        }
    }
    
    @IBAction func nameReturnTapped(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func scoreReturnTapped(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
}
