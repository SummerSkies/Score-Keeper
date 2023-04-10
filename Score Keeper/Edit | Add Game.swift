//
//  PlayerList.swift
//  Score Keeper
//
//  Created by Juliana Nielson on 3/24/23.
//

import UIKit

class EditAddGame: UITableViewController, PlayerCellDelegate {
    
    @IBOutlet weak var gameTypeTextField: UITextField!
    
    var game: Game? //Used to pass in a game from the list of games when editing
    var players = [Player]() //Holds the passed game's players for easy access
    
    //For a custom section header(items):
    let editButton = UIButton(frame: CGRectMake(325, 5, 50, 20)) //Custom editButtonItem
    let headerLabel = UILabel(frame: CGRect(x: 20, y: 5, width: 100, height: 20)) //The label that will hold the section header
    //Colors:
    let defaultButtonColor = UIColor(red: 50.0 / 255.0, green: 116.0 / 255.0, blue: 220.0 / 255.0, alpha: 1) //The color of the edit button's title
    let highlightedButtonColor = UIColor(red: 196 / 255.0, green: 196 / 255.0, blue: 196 / 255.0, alpha: 1) //The color of a button being pressed (e.g. when highlighted)
    let labelColor = UIColor(red: 138 / 225, green: 138 / 225, blue: 142 / 225, alpha: 1) //The color of the header's title
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if editButton.currentTitle == nil {
            editButton.setTitle("Edit", for: .normal)
            //Sets the custom edit button's title if it doesn't have one
        }
        
        if let game = game {
            //If editing an existing game, pass in values
            navigationItem.title = "Edit Game"
            gameTypeTextField.text = game.type
            players = game.players
        } else {
            //If creating a new game
            navigationItem.title = "New Game"
        }
        players.sort { $0.name < $1.name }
        tableView.reloadData()
        //Sorts the players alphabetically by name, then reloads the table view so the cells show the accurate data
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
        //The number of rows in each section will always be equal to the number of players in the game
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Set up each cell to hold the custom layout specified in the storyboard and Game Cell file
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Player Cell", for: indexPath) as! PlayerCell
        //Step 1: Dequeue cell; This calls the previously mentioned custom cell to populate the table view, or creates one if it doesn't exist. Because the custom cell is a template, it can be reused for every cell in the tableview to save performance.
        
        cell.delegate = self //Connects this class file to the cell's delegate, allowing it to call the function defined inside said delegate
        
        let player = players[indexPath.row]
        cell.update(with: player)
        //Step 2: Update cell with appropriate info
        
        return cell
        //Step 3: Return cell; Place it in the tableView.
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        //Allows editing on the tableView
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //Tells the system what to do then editing is activiated
        if editingStyle == .delete {
            tableView.performBatchUpdates({ //Animates the removal of a cell
                players.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .right)
            }) { _ in
                tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //Creates a view to replace section headers
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50)) //The view that will be returned as the header
        
        //Configure label
        headerLabel.text = "Players"
        headerLabel.textColor = labelColor
        headerLabel.font = UIFont.preferredFont(forTextStyle: .headline) .withSize(15)
        
        //Configure button
        editButton.setTitleColor(defaultButtonColor, for: .normal)
        editButton.setTitleColor(highlightedButtonColor, for: .highlighted)
        editButton.addTarget(self, action: #selector(EditAddGame.pressed(sender:)), for: .touchUpInside)
        
        //Add label to header
        headerView.addSubview(headerLabel)
        
        if !players.isEmpty {
            headerView.addSubview(editButton)
            //If there are cells to edit, add edit button to label
        }
        
        return headerView
        //Add view to section's header
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        //Prepare to unwind to SelectedGameViwer; pass info back to source
        
        guard segue.identifier == "Save Game Unwind" else { return }
        //Only pass using the correct segue
        
        //Store values that will be passed for cleaner code:
        let gameType = gameTypeTextField.text ?? ""
        
        if game != nil {
            game?.type = gameType
            game?.players = players
            //If editing an existing game, update values
        } else {
            game = Game(type: gameType, players: players)
            //Else if creating a new game, make a new game with the passed vaues
        }
    }

    @objc func pressed(sender: UIButton!) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        //Custom function to change the custom editButton to act like the original editButtonItem
        
        if tableView.isEditing {
            editButton.setTitle("Done", for: .normal)
            editButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        } else if tableView.isEditing == false {
            editButton.setTitle("Edit", for: .normal)
            editButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        }
    }
    
    func updateScores(cell: PlayerCell) {
        //Player cell's delegate function body
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        
        for player in players {
            guard let indexOfExistingPlayer = players.firstIndex(of: player) else { continue }
            guard indexPath == IndexPath(row: indexOfExistingPlayer, section: 0) else { continue }
            
            guard let playerScore = cell.playerScoreLabel.text else { return cell.playerScoreLabel.text = "0" }
            guard let currentScore = Int(playerScore) else { return cell.playerScoreLabel.text = "0" }
            
            players[indexOfExistingPlayer].score = currentScore
            return
        }
    }
    
    //If the user taps "return" on any specified keyboard, close the keyboard:
    @IBAction func typeReturnTapped(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func unwindFromAddEditPlayer(segue: UIStoryboardSegue) {
        //Activated when returning from Edit | Add Player; takes passed values and adds them to the table view.
        //This is the recieving end of prepare:for Segue in the source view controller (this time being Edit | Add Player)
        //Even though it is an @IBAction, it does not need a connection to anything.
        
        guard segue.identifier == "Save Game Unwind" else { return }
        let sourceViewController = segue.source as! EditAddPlayer
        //Only pass info if using the correct segue, and if passing from the correct view controller
        
        if let player = sourceViewController.player { //If source has a player
            if let indexOfExistingPlayer = players.firstIndex(of: player) {
                players[indexOfExistingPlayer] = player
                tableView.reloadRows(at: [IndexPath(row: indexOfExistingPlayer, section: 0)], with: .automatic)
                //If player exists in current view, update values
            } else {
                let newIndex = IndexPath(row: players.count, section: 0)
                players.append(player)
                tableView.insertRows(at: [newIndex], with: .automatic)
                //Else, create a new player in the players array with provided values
            }
        }
        players.sort { $0.name < $1.name }
        tableView.reloadData()
        //Sorts the players alphabetically by name, then reloads the table view so the cells show the accurate data
    }
    
    @IBSegueAction func editPlayer(_ coder: NSCoder, sender: Any?) -> EditAddPlayer? {
        //Used to pass info to Edit | Add Player; takes current values and passes them to the destination view.
        //Unlike prepare:for segue, @IBSegueAction is a connection with a one-sided requirement. It is an info sender without need for a recieveing end. However, it can only be used to pass info to a view directly connected to its own navigation controller.
        //It is created by making a connection from the source view script to the segue between the destination view and its navigation controller
        
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else { return nil }
        //Makes sure the sender cell is of the correct type and index
        
        tableView.deselectRow(at: indexPath, animated: true)
        //Deselects the row before passing to new view; this is an asthetic change, mostly

        let destinationView = EditAddPlayer(coder: coder) //Instance of destination view
        destinationView?.player = players[indexPath.row] //Adds current player to the instance view to prepare to be passed

        return destinationView
        //Pass the selected view instance, with all values to be passed, to the destination view
    }
}
