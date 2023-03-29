import UIKit

/*
 To-Dos:
 
 -View 3: GameDetails (for editing or adding games)
    -From PlayerList
        -Accessed through GamesList Plus button (add segue)
        -Accessed through GameViewer Edit button (edit segue)
    -"Edit Game" navigation title (edit segue) or "New Game" (add segue)
    -2 sections:
        0: "Game Details" section header, custom cell GameEditCell
        -Game type label
        -Game type text field
        1: "Players" section header
        -as is
    -Plus button to "Add Player"
    -cancel button
    -save button
 
 Script 3: GamePlayerList
    -Remove sorting when changing values -- order alphabetically by name instead
    -Keep intelligent edit button
    -Update all section calls to 1
    -Pass info from game viewer
    -Unwind segue to GameViewer (save and cancel buttons)
 
 View 4: PlayerDetails (add and edit players)
    -As is
 
 Script 4: PlayerDetails
    -Update script calls as needed
 
 UNIFY PLAYER LISTS
    -Unique list of players per game
    -Winner for each game is the player with the highest score
 
 Future Polishes:
 -Test keyboards on player detail view
 -Disable save button on deail view if applicable
 -Fix disabling steppers on player list (so it is not diabled from first run)
 -Replace all preparefor:(segue) funcs with IBSegueActions
 -make default cells for if no players or games have been created yet
 */
