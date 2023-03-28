//
//  DetailView.swift
//  Score Keeper
//
//  Created by Juliana Nielson on 3/27/23.
//

import UIKit
import Foundation

class PlayerDetailView: UIViewController {
    
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
            navigationItem.title = player.name
            playerNameTextField.text = player.name
            playerScoreTextField.text = String(player.score)
        } else {
            //If creating a new player
            navigationItem.title = "New Player"
        }
        
        //updateSaveButtonState()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        //Used to pass info to the PlayerList controller
        
        guard segue.identifier == "Save Unwind" else { return }
        
        let name = playerNameTextField.text!
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
    /*
    func updateSaveButtonState() {
        
        /*Save button disabled if:
            Score text is invalid:
            - Contains any non-number characters
            - Value is nil
            - Value is empty
            - Value is greater than 100
            - Value is less than 0
         
            Name text is invalid:
            - Value is nil
            - Value is empty
         
         */
        
        guard let playerScoreText = playerScoreTextField.text else {
            print("PlayerNameTextField is nil")
            return saveButton.isEnabled = false
        }
        
        let regex = try! NSRegularExpression(pattern: nonDidgitPattern)
        let matches = regex.matches(in: playerScoreText, range: NSRange(playerScoreText.startIndex..., in: playerScoreText))
        
        if matches.count > 0 {
            print("Player score may only contain numbers.")
            saveButton.isEnabled = false
        } else {
            switch playerScoreTextField.text {
            case nil:
                print("PlayerScoreTextField is nil")
                return saveButton.isEnabled = false
            case "":
                print("Please enter a player score.")
                return saveButton.isEnabled = false
            default:
                if Int(playerScoreText)! > 100 || Int(playerScoreText)! < 0 {
                    print("Score cannot be more than 100 or less than 0.")
                    saveButton.isEnabled = false
                }
            }
        }
    }
     */
    
    @IBAction func nameReturnTapped(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func nameEdited(_ sender: UITextField) {
        //updateSaveButtonState()
    }
    
    @IBAction func scoreReturnTapped(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func scoreEdited(_ sender: UITextField) {
        //updateSaveButtonState()
    }
}
