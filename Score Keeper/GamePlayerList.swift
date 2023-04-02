//
//  PlayerList.swift
//  Score Keeper
//
//  Created by Juliana Nielson on 3/24/23.
//

import UIKit

class GamePlayerList: UITableViewController, PlayerCellDelegate {
    
    @IBOutlet weak var gameTypeTextField: UITextField!
    
    var game: Game?
    var players = [Player]()
    let editButton = UIButton(frame: CGRectMake(325, 5, 50, 20))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if editButton.currentTitle == nil {
            editButton.setTitle("Edit", for: .normal)
        }
        
        if let game = game {
            //If editing an existing game
            navigationItem.title = "Edit Game"
            gameTypeTextField.text = game.type
            players = game.players
        } else {
            //If creating a new game
            navigationItem.title = "New Game"
        }
        
        players.sort { $0.name < $1.name }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Player Cell", for: indexPath) as! PlayerCell
        
        cell.delegate = self
        
        let player = players[indexPath.row]
        cell.update(with: player)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.performBatchUpdates({
                players.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .right)
            }) { _ in
                tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let defaultColor = UIColor(red: 50.0 / 255.0, green: 116.0 / 255.0, blue: 220.0 / 255.0, alpha: 1)
        let disabledColor = UIColor(red: 196 / 255.0, green: 196 / 255.0, blue: 196 / 255.0, alpha: 1)
        let headerColor = UIColor(red: 138 / 225, green: 138 / 225, blue: 142 / 225, alpha: 1)
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let sectionHeader = UILabel(frame: CGRect(x: 20, y: 5, width: 100, height: 20))
        
        sectionHeader.text = "Players"
        sectionHeader.textColor = headerColor
        sectionHeader.font = UIFont.preferredFont(forTextStyle: .headline) .withSize(15)
        
        editButton.setTitleColor(defaultColor, for: .normal)
        editButton.setTitleColor(disabledColor, for: .highlighted)
        editButton.addTarget(self, action: #selector(GamePlayerList.pressed(sender:)), for: .touchUpInside)
        
        headerView.addSubview(sectionHeader)
        
        if !players.isEmpty {
            headerView.addSubview(editButton)
        }
        
        return headerView
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "Save Game Unwind" else { return }
        
        let gameType = gameTypeTextField.text ?? ""
        
        if game != nil {
            game?.type = gameType
            game?.players = players
        } else {
            game = Game(type: gameType, players: players)
        }
    }

    @objc func pressed(sender: UIButton!) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        
        if tableView.isEditing {
            editButton.setTitle("Done", for: .normal)
            editButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        } else if tableView.isEditing == false {
            editButton.setTitle("Edit", for: .normal)
            editButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        }
    }
    
    func updateScores(cell: PlayerCell) {
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
    
    @IBAction func typeReturnTapped(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func unwindFromPlayerDetails(segue: UIStoryboardSegue) {
        //Activated when returning from PlayerDetails
        guard segue.identifier == "Save Player Unwind" else { return }
        let sourceViewController = segue.source as! PlayerDetails
        
        if let player = sourceViewController.player {
            if let indexOfExistingPlayer = players.firstIndex(of: player) {
                //If the selected player already exists in the team array
                players[indexOfExistingPlayer] = player
                tableView.reloadRows(at: [IndexPath(row: indexOfExistingPlayer, section: 0)], with: .automatic)
                //Replace old player info with editied player info
            } else {
                //If adding a new player
                let newIndex = IndexPath(row: players.count, section: 0)
                players.append(player)
                tableView.insertRows(at: [newIndex], with: .automatic)
                //Add player to team
            }
        }
        players.sort { $0.name < $1.name }
        tableView.reloadData()
    }
    
    @IBSegueAction func editPlayer(_ coder: NSCoder, sender: Any?) -> PlayerDetails? {
        //Activated when moving to PlayerDetails
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else { return nil }
        //Make sure the cell is a cell
        tableView.deselectRow(at: indexPath, animated: true)

        let detailView = PlayerDetails(coder: coder)
        detailView?.player = players[indexPath.row]

        return detailView
        //Pass the selected player to the new view
    }
}
