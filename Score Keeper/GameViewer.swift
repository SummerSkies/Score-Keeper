//
//  ViewGame.swift
//  Score Keeper
//
//  Created by Juliana Nielson on 3/29/23.
//

import UIKit

class GameViewer: UITableViewController {

    var game: Game?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let game = game {
            navigationItem.title = game.type
        }
        
        game?.players.sort { $0.score > $1.score }
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return game?.players.count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let game = game!
            let gameViewCell = tableView.dequeueReusableCell(withIdentifier: "Game View Cell", for: indexPath) as! GameViewCell
            gameViewCell.update(with: game)
            
            gameViewCell.separatorInset = UIEdgeInsets(top: 0, left: tableView.frame.size.width, bottom: 0, right: 0);
            
            return gameViewCell
        } else {
            let player = game!.players[indexPath.row]
            let playerCell = tableView.dequeueReusableCell(withIdentifier: "Player Cell", for: indexPath) as! PlayerCell
            playerCell.update(with: player)
            
            return playerCell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
        if section == 1{
            return "Players"
        }
        return nil
    }
}
