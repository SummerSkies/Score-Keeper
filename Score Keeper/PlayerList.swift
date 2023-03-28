//
//  PlayerList.swift
//  Score Keeper
//
//  Created by Juliana Nielson on 3/24/23.
//

import UIKit

class PlayerList: UITableViewController {
    
    static var team = [
        Player(name: "Player1", score: 1),
        Player(name: "Player2", score: 2),
        Player(name: "Player3", score: 3),
        Player(name: "Player4", score: 4),
        Player(name: "Player5", score: 5)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        
        PlayerList.team.sort { $0.score > $1.score }
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlayerList.team.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Player Cell", for: indexPath) as! PlayerCell
        
        let player = PlayerList.team[indexPath.row]
        cell.update(with: player)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.performBatchUpdates({
                PlayerList.team.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .right)
            }) { _ in
                tableView.reloadData()
            }
        }
    }
    
    @IBAction func unwindFromDetailView(segue: UIStoryboardSegue) {
        //Activated when returning from DetailView
        guard segue.identifier == "Save Unwind" else { return }
        let sourceViewController = segue.source as! DetailView

        if let player = sourceViewController.player {
            if let indexOfExistingPlayer = PlayerList.team.firstIndex(of: player) {
                //If the selected player already exists in the team array
                PlayerList.team[indexOfExistingPlayer] = player
                tableView.reloadRows(at: [IndexPath(row: indexOfExistingPlayer, section: 0)], with: .automatic)
                //Replace old player info with editied player info
            } else {
                //If adding a new player
                let newIndex = IndexPath(row: PlayerList.team.count, section: 0)
                PlayerList.team.append(player)
                tableView.insertRows(at: [newIndex], with: .automatic)
                //Add player to team
            }
        }
        PlayerList.team.sort { $0.score > $1.score }
        tableView.reloadData()
    }
    
    @IBSegueAction func editPlayer(_ coder: NSCoder, sender: Any?) -> DetailView? {
        //Activated when moving to DetailView
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) else { return nil }
        //Make sure the cell is a cell
        tableView.deselectRow(at: indexPath, animated: true)

        let detailView = DetailView(coder: coder)
        detailView?.player = PlayerList.team[indexPath.row]

        return detailView
        //Pass the selected player to the new view
    }
}
