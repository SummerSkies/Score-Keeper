//
//  DetailView.swift
//  Score Keeper
//
//  Created by Juliana Nielson on 3/27/23.
//

import UIKit
import Foundation

class EditAddPlayer: UIViewController {
    
    @IBOutlet weak var playerNameTextField: UITextField!
    @IBOutlet weak var playerScoreTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var player: Player? //Used to pass in a player from a game when editing
    let nonDidgitPattern = "[^0-9]" //Used to find if a string has any non-number characters
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerScoreTextField.keyboardType = .numberPad //Score feild uses a numberpad
        
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
        //Used to pass info to Edit | Add Game; takes current values and passes them to the destination view.
        //This is the sending end of @IBAction func unwindFromAddEditPlayer
        
        guard segue.identifier == "Save Player Unwind" else { return }
        //Only pass info if using the correct segue
        
        let name = playerNameTextField.text!
        let score = Int(playerScoreTextField.text ?? "") ?? 0
        //info to pass
        
        if player != nil {
            player?.name = name
            player?.score = score
            //If player exists, pass updated values
        } else {
            player = Player(name: name, score: score)
            //Else, pass a new player with provided values
        }
    }
    
    //If the user taps "return" on any specified keyboard, close the keyboard:
    @IBAction func nameReturnTapped(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func scoreReturnTapped(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
}
