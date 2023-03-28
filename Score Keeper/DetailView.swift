//
//  DetailView.swift
//  Score Keeper
//
//  Created by Juliana Nielson on 3/27/23.
//

import UIKit

class DetailView: UIViewController {
    
    @IBOutlet weak var playerNametextField: UITextField!
    @IBOutlet weak var playerScoreTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var player: Player?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let player = player {
            //If editing an existing player
            navigationItem.title = player.name
            playerNametextField.text = player.name
            playerScoreTextField.text = String(player.score)
        } else {
            //If creating a new player
            navigationItem.title = "New Player"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        //Used to pass info to the PlayerList controller
        
        guard segue.identifier == "Save Unwind" else { return }
        
        let name = playerNametextField.text!
        let score = Int(playerScoreTextField.text ?? "") ?? 0
        //info to pass
        
        if player != nil {
            player?.name = name
            player?.score = score
            //If player exists, pass in values
        } else {
            player = Player(name: name, score: score)
            //Else, pass in an empty template for the user to fill in
        }
    }
    
    @IBAction func nameReturnTapped(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func scoreReturnTapped(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
}
