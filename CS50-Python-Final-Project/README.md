# Let's Play Darts!
#### Video Demo:  https://youtu.be/OTVrAfHbTe0
#### Description:
As my final project for the CS50P course I decided to write a program that keeps track of everything when playing a game of darts. All the users have to do is type in their score after throwing the darts. There's even a 'caller' who acts like a real world one by repeating your score and telling you how much you have left before you throw when able to finish. At the end of every leg and after the match has ended players are shown their 3-dart average for the leg and the entire match respectively.

To be able to call the scores I decided to `import pyttsx3`. This is the only library that needed to be imported for the program to run. The voice is pretty robotic, so in the future I might want to change this to a more suitable voice to increase the immersion of the users.

First the users will be prompted for their names. All possibilities are allowed. Only when entering nothing at all, will the user be reprompted to enter a name. After entering their names, the users may choose with how many points they would like to start each leg. A standard dart match usually starts at 501, but the users are free to choose any amouny as long as it's larger than 1 (since you should finish with a double an amount of only one point would be impossible to finish). Finally, they can choose how many legs one needs to win in order to win the match.
To avoid any errors and be able to reprompt the user in case of an invalid value I chose to use a `while True` loop with exception handling inside.

Before starting the match the program has to create some variables in order to calculate the averages and keep track of the legs.

In a match, the program will loop over the same code written to represent one leg until one player wins the required amount of legs. In that case, the program will break out of the loop and goes on to calculate and show the match averages.
While technically not necessary because the program will always break out of the loop at the right time, I chose a for loop that would loop maximally as many times as when players would play a deciding leg:
`for leg in range(1, best_of_legs + 1)`
The reason I went with this option is because it looked clear to me since this represents the 'best of x legs' way of talking about the game. It also allowed me to use the leg variable in the next few lines by having the range start at 1.

Before the leg starts the caller tells who should throw first. This will be Player 1 in the uneven legs and Player 2 in the even legs. Next, we make sure all necessary variables are reset to the correct number in order to start a new leg.

Since a leg consists of both players alternately throwing their darts until one player gets to 0, I used a `while True` loop that keeps repeating until that condition is met. Because Player 2 throws first in even legs I had to add the following condition:
```
if leg % 2 == 0 and turns_player2 == 0:
                pass
```
This ensures Player 2 is prompted first in the even legs, but Player 1 does get prompted during the second loop since then `turns_player2 == 1`.
During a player's turn they are prompted for their score. First this value is validated. For example, when entering a score of 200, with the highest possible throw in darts being 180, the user will be reprompted to enter a valid score. This is also the case for impossible throws below this the maximum of 180.

When a throw is validated this score will be compared to the amount of points the user still needed to throw. If your throw is higher or one less than your required score, the caller will say 'No score.'. Also ending up on exactly 0 points left when you had a score that can not be finished according to the rules (having to finish with a double, either the outer ring or the bull's eye) will be treated as a bust instead of a leg winning finish. Only when scoring the exact amount of points needed without ending with a double, for example hitting the single 16 instead of double 8, will the users themselves have to enter a score of 0. Since the program only takes the total score of a throw, it cannot distinguish between these scenarios. A solution would be to have the user enter the result of every single dart. This would allow for more options to analyze a player's game, but would also make using the program a lot more tedious, since now they have to enter three times as many numbers.

Whenever a player gets their remaining score to 0, the program will break out of the loop and assign new variables based on who won and who lost the leg. This is important to accurately calculate the leg average. The winner will be asked how many darts were needed to finish the leg in their final turn. Again, I chose to make it as mistake-proof as possible by creating lists of two- and three-dart-finishes, so that players can never say they used only one dart to finish a number that would at least require two. When finishing a three-dart-finish the user isn't even prompted and the function automatically returns 3.

After every leg, the caller tells the users how many legs every player has won. When one player reaches the required amount of legs the match average is also calculated and shown to the users.

Since I love playing darts I was excited to write a program I could use myself. Of course there are some very fancy apps out there that can even analyze a live video to determine the amount of points thrown. While I don't want to take it that far, I still feel like improving and expanding this program more. First, I want to make a GUI for it to also make it more visually appealing. Here, I would also like to include an 'Undo' button, just in case a user types in a wrong, but valid, score. Next, it would be nice to be able to add players to a database and store the statistics of all their matches as to create a complete player profile and possibly even set up tournaments between all players. Adding other games besides 'getting to 0 points' would be another step. With what I've learned so far it looks like a lot would have to be rewritten since it seems more appropriate to use classes and thus switch to object-oriented programming. Let me just consider that a new challenge in my programming journey.
