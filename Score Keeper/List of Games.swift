//
//  GamesList.swift
//  Score Keeper
//
//  Created by Juliana Nielson on 3/28/23.
//

import UIKit

class ListOfGames: UITableViewController, GameViewerDelegate {
    
    static var games = [
        Game(type: "Scum", players: [
            Player(name: "Player1", score: 1),
            Player(name: "Player2", score: 2),
            Player(name: "Player3", score: 3),
            Player(name: "Player4", score: 4),
            Player(name: "Player5", score: 5)
        ]),
        Game(type: "Uno", players: [
            Player(name: "Player6", score: 6),
            Player(name: "Player7", score: 7),
            Player(name: "Player8", score: 8),
            Player(name: "Player9", score: 9),
            Player(name: "Player10", score: 10)
        ]),
        Game(type: "Go Fish", players: [
            Player(name: "Player11", score: 11),
            Player(name: "Player12", score: 12),
            Player(name: "Player13", score: 13),
            Player(name: "Player14", score: 14),
            Player(name: "Player15", score: 15)
        ])
    ] //The data array which holds all game info, including player data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem //Adds an editButtonItem
        
        //Updates winner values if winner is nil when it shouldn't be
        for (index, game) in ListOfGames.games.enumerated() {
            if game.winner == nil {
                ListOfGames.games[index].updateWinner()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Updates winner values when passed back from SelectedGameView
        for game in ListOfGames.games {
            guard let winner = game.winner else { return }
            guard let indexOfExistingGame = ListOfGames.games.firstIndex(of: game) else { return }
            let cell = tableView.cellForRow(at: IndexPath(row: indexOfExistingGame, section: 0))
            guard let cell = cell as? GameCell else { return }
            guard let winnerLabel = cell.gameWinnerLabel.text else { return }
            if !winnerLabel.contains(winner.name) {
                cell.gameWinnerLabel.text = "Winner: \(winner.name)"
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListOfGames.games.count
        //The number of rows in the table view will always be equal to the number of games in the data array
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Set up each cell to hold the custom layout specified in the storyboard and cell files
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Game Cell", for: indexPath) as! GameCell
        //Step 1: Dequeue cell; This calls the previously mentioned custom cell to populate the table view, or creates one if it doesn't exist. Because the custom cell is a template, it can be reused for every cell in the tableview to save performance.
        
        var game = ListOfGames.games[indexPath.row]
        game.updateWinner() //updates game winner -- this is probably not necissary because winner is updated in both ViewDid load (for if it is nil) and ViewDidAppear (for when new info is passed). Be sure to check this later.
        cell.update(with: game)
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
                ListOfGames.games.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .right)
            }) { _ in
                tableView.reloadData()
            }
        }
    }
    
    func passGame(game: Game) {
        //SelectedGameView's delegate function body
        guard let indexOfExistingGame = ListOfGames.games.firstIndex(of: game) else { return }
        ListOfGames.games[indexOfExistingGame] = game
        tableView.reloadRows(at: [IndexPath(row: indexOfExistingGame, section: 0)], with: .automatic)
    }
    
    @IBAction func unwindFromEditAddGame(segue: UIStoryboardSegue) {
        //Activated when returning from Edit | Add Game; takes passed values and adds them to the table view.
        //This is the recieving end of prepare:for Segue in the source view controller (this time being Edit | Add Game)
        //Even though it is an @IBAction, it does not need a connection to anything.
        
        guard segue.identifier == "Save Game Unwind" else { return }
        let sourceViewController = segue.source as! EditAddGame
        //Only pass info if using the correct segue, and if passing from the correct view controller
        
        if let game = sourceViewController.game { //If source has a game
            let newIndex = IndexPath(row: ListOfGames.games.count, section: 0)
            ListOfGames.games.append(game)
            tableView.insertRows(at: [newIndex], with: .automatic)
            //update values
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        //Used to pass info to SelectedGameView; takes current values and passes them to the destination view.
        //This func has no pass partner because its destination is accessible only one way. Information is passed back through the delegate.
        
        guard segue.identifier == "View Game" else { return }
        guard let destination = segue.destination as? SelectedGameView else { return }
        guard let cell = sender as? GameCell, let indexPath = tableView.indexPath(for: cell) else { return }
        //Only pass info if using the correct segue, if passing from the correct view controller, and if sender cell is of correct type and index
        
        tableView.deselectRow(at: indexPath, animated: true)
        //Deselects the row before passing to new view; this is an asthetic change, mostly
        
        destination.game = ListOfGames.games[indexPath.row] //Adds current game to the instance view to prepare to be passed
        destination.game?.updateWinner() //update game winner
    }
}
