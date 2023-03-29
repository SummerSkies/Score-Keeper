//
//  GamesList.swift
//  Score Keeper
//
//  Created by Juliana Nielson on 3/28/23.
//

import UIKit

class GamesList: UITableViewController {

    var games = [
        Game(type: "Scum", winner: GamePlayerList.team[0], players: [GamePlayerList.team[0], GamePlayerList.team[1]]),
        Game(type: "Uno", winner: GamePlayerList.team[2], players: [GamePlayerList.team[2], GamePlayerList.team[3]]),
        Game(type: "Go Fish", winner: GamePlayerList.team[4], players: [GamePlayerList.team[1], GamePlayerList.team[4]])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Game Cell", for: indexPath) as! GameCell
        
        let game = games[indexPath.row]
        cell.update(with: game)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.performBatchUpdates({
                games.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .right)
            }) { _ in
                tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "View Game" else { return }
        guard let destination = segue.destination as? GameViewer else { return }
        guard let cell = sender as? GameCell, let indexPath = tableView.indexPath(for: cell) else { return }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        destination.game = games[indexPath.row]
    }
}
