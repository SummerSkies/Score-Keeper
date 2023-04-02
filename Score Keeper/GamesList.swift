//
//  GamesList.swift
//  Score Keeper
//
//  Created by Juliana Nielson on 3/28/23.
//

import UIKit

class GamesList: UITableViewController, GameViewerDelegate {
    
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
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        for (index, game) in GamesList.games.enumerated() {
            if game.winner == nil {
                GamesList.games[index].updateWinner()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        for game in GamesList.games {
            guard let winner = game.winner else { return }
            guard let indexOfExistingGame = GamesList.games.firstIndex(of: game) else { return }
            let cell = tableView.cellForRow(at: IndexPath(row: indexOfExistingGame, section: 0))
            guard let cell = cell as? GameCell else { return }
            guard let winnerLabel = cell.gameWinnerLabel.text else { return }
            if !winnerLabel.contains(winner.name) {
                cell.gameWinnerLabel.text = "Winner: \(winner.name)"
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GamesList.games.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Game Cell", for: indexPath) as! GameCell
        
        var game = GamesList.games[indexPath.row]
        game.updateWinner()
        cell.update(with: game)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.performBatchUpdates({
                GamesList.games.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .right)
            }) { _ in
                tableView.reloadData()
            }
        }
    }
    
    func passGame(game: Game) {
        guard let indexOfExistingGame = GamesList.games.firstIndex(of: game) else { return }
        GamesList.games[indexOfExistingGame] = game
        tableView.reloadRows(at: [IndexPath(row: indexOfExistingGame, section: 0)], with: .automatic)
    }
    
    @IBAction func unwindFromGamePlayerList(segue: UIStoryboardSegue) {
        //Activated when returning from GamePlayerList, aka when saving a new game
        guard segue.identifier == "Save Game Unwind" else { return }
        let sourceViewController = segue.source as! GamePlayerList
        
        if let game = sourceViewController.game {
            let newIndex = IndexPath(row: GamesList.games.count, section: 0)
            GamesList.games.append(game)
            tableView.insertRows(at: [newIndex], with: .automatic)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //replace with IBSegueAction later
        guard segue.identifier == "View Game" else { return }
        guard let destination = segue.destination as? GameViewer else { return }
        guard let cell = sender as? GameCell, let indexPath = tableView.indexPath(for: cell) else { return }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        destination.game = GamesList.games[indexPath.row]
        destination.game?.updateWinner()
    }
}
