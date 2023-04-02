//
//  ViewGame.swift
//  Score Keeper
//
//  Created by Juliana Nielson on 3/29/23.
//

import UIKit

protocol GameViewerDelegate: AnyObject {
    func passGame(game: Game)
}

class GameViewer: UITableViewController, UINavigationControllerDelegate {

    let gamesList = GamesList()
    var game: Game?
    
    weak var delegate: GameViewerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        if var game = game {
            navigationItem.title = game.type
            game.players.sort { $0.score > $1.score }
            tableView.reloadData()
            game.updateWinner()
        }
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
        if section == 1 {
            return "Players"
        }
        return nil
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController === navigationController.viewControllers[0] {
            if let game = game {
                self.delegate = gamesList
                self.delegate?.passGame(game: game)
            }
        }
    }
    
    @IBAction func unwindFromGamePlayerList(segue: UIStoryboardSegue) {
        guard segue.identifier == "Save Game Unwind" else { return }
        let sourceViewController = segue.source as! GamePlayerList
        
        if let passedGame = sourceViewController.game {
            game = passedGame
        }
        game?.updateWinner()
        game?.players.sort { $0.score > $1.score }
        tableView.reloadData()
    }

    @IBSegueAction func editGame(_ coder: NSCoder, sender: Any?) -> GamePlayerList? {
        let detailView = GamePlayerList(coder: coder)
        detailView?.game = game
        
        return detailView
    }
}
