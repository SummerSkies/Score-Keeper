//
//  GamesList.swift
//  Score Keeper
//
//  Created by Juliana Nielson on 3/28/23.
//

import UIKit

class GamesList: UITableViewController {

    var games = [
        Game(type: "Scum", winner: PlayerList.team[0], players: [PlayerList.team[0], PlayerList.team[1]]),
        Game(type: "Uno", winner: PlayerList.team[2], players: [PlayerList.team[2], PlayerList.team[3]]),
        Game(type: "Go Fish", winner: PlayerList.team[4], players: [PlayerList.team[1], PlayerList.team[4]])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
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
}
