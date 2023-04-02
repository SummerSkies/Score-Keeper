import UIKit

/*
 To-Dos:
 Starting backwards;
 -PlayerDetails √√√
 -GamePlayerList
    -Save √
    -Cancel √
 -GameViewer
    -Pass save info back from GamePlayerList (edit) √
 -GameList
    -Pass save info back from GamePlayerList (new) √
    -Pass save info back from GameViewer
 
 -Update winner in GameViewer
 
 -USE POLISHES TO STOP CRASHES: your code only works if the info passed has all of its required info; Don't allow the user to save anything if it does not.
 
 -No Winner Yet is never shown because score defaults to 0
    
 
 Future Polishes:
 -Test keyboards on player detail view
 -Disable save button on deail view if applicable
 -Fix disabling steppers on player list (so it is not diabled from first run)
 -Replace all preparefor:(segue) funcs with IBSegueActions (SIMPLIFIY- I'm like 90% sure you have like 80x the amount of segue stuff than you need
 -make default cells for if no players or games have been created yet
 -Default winner view if no winner exists
 -Animate title change on the custom edit button
 -Rename everything to be clearer:
    -But to what?
 */
