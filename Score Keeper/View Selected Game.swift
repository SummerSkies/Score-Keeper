//
//  ViewGame.swift
//  Score Keeper
//
//  Created by Juliana Nielson on 3/29/23.
//

import UIKit

protocol GameViewerDelegate: AnyObject {
    func passGame(game: Game) //Passes the game info from Edit | Add Game when returning from it. A delegate is used because the unwind button used is part of the navigation controller, which cannot be connected to other views like other buttons can.
}

class SelectedGameView: UITableViewController {

    let listOfGames = ListOfGames() //Instance of ListOfGames, used to access content
    var game: Game? //Used to pass in a game from the list of games when editing
    
    weak var delegate: GameViewerDelegate? //Allows connection from this class to another class via the delegate; set to weak to avoid a strong reference cycle, or retain cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //Unwrap game, then pass in values. Force unwrapping is used because this view is inaccessible without passing in a game.
        var game = game!
        navigationItem.title = game.type
        game.players.sort { $0.score > $1.score }
        tableView.reloadData()
        game.updateWinner()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
        //There will be two sections in the table view. The first is reserved for the Game Info Cell, while the second is reserved for all Player Cells.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return game?.players.count ?? 0
        }
        //The number of rows in the first section will always be 1, while the number of rows in the second section will always be equal to the number of players in the game
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Set up each cell to hold the custom layout specified in the storyboard and cell files
        
        //This view has two types of cells, and the type of cell displayed will depend on which section it appears in
        if indexPath.section == 0 {
            let gameViewCell = tableView.dequeueReusableCell(withIdentifier: "Game View Cell", for: indexPath) as! GameInfoCell
            //Step 1: Dequeue cell; This calls the previously mentioned custom cell to populate the table view, or creates one if it doesn't exist. Because the custom cell is a template, it can be reused for every cell in the tableview to save performance.
            
            let game = game! //Unwrap game. Force unwrapping is used because this view is inaccessable unless a game is passed to it.
            gameViewCell.update(with: game)
            //Step 2: Update cell with appropriate info
            
            return gameViewCell
            //Step 3: Return cell; Place it in the tableView.
        } else {
            let player = game!.players[indexPath.row] //Unwrap game to access players. Force unwrapping is used because this view is inaccessable unless a game is passed to it.
            
            let playerCell = tableView.dequeueReusableCell(withIdentifier: "Player Cell", for: indexPath) as! PlayerCell
            //Step 1: Dequeue cell; This calls the previously mentioned custom cell to populate the table view, or creates one if it doesn't exist. Because the custom cell is a template, it can be reused for every cell in the tableview to save performance.
            
            playerCell.update(with: player)
            //Step 2: Update cell with appropriate info
            
            return playerCell
            //Step 3: Return cell; Place it in the tableView.
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection
                                section: Int) -> String? {
        if section == 1 {
            return "Players"
        }
        return nil
        //Set a header title "Players" for the section which will hold the player cells
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController === navigationController.viewControllers[0] {
            if let game = game {
                self.delegate = listOfGames //Connects the ListOfGames class file to this class file's delegate, allowing it to call the function defined inside said delegate
                self.delegate?.passGame(game: game) //Delegate call
            }
        }
    }
    
    @IBAction func unwindFromEditAddGame(segue: UIStoryboardSegue) {
        //Activated when returning from Edit | Add Game; takes passed values and adds them to the table view.
        //This is the recieving end of prepare:for Segue in the source view controller (this time being Edit | Add Game)
        //Even though it is an @IBAction, it does not need a connection to anything.
        
        guard segue.identifier == "Save Game Unwind" else { return }
        let sourceViewController = segue.source as! EditAddGame
        //Only pass info if using the correct segue, and if passing from the correct view controller
        
        if let passedGame = sourceViewController.game { //If source has a game
            game = passedGame
            //update values
        }
        game?.updateWinner() //Update winner the game before passing
        game?.players.sort { $0.score > $1.score }
        tableView.reloadData()
        //Sorts the players in descending order by score, then reloads the table view so the cells show the accurate data
    }

    @IBSegueAction func editGame(_ coder: NSCoder, sender: Any?) -> EditAddGame? {
        //Used to pass info to Edit | Add Game; takes current values and passes them to the destination view.
        //Unlike prepare:for segue, @IBSegueAction is a connection with a one-sided requirement. It is an info sender without need for a recieveing end. However, it can only be used to pass info to a view directly connected to its own navigation controller.
        //It is created by making a connection from the source view script to the segue between the destination view and its navigation controller
        
        let detailView = EditAddGame(coder: coder) //Instance of destination view
        detailView?.game = game //Adds current game to the instance view to prepare to be passed
        
        return detailView
        //Pass the selected view instance, with all values to be passed, to the destination view
    }
}
