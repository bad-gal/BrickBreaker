The game has four states

Ball in paddle: When the game starts or when we lose the ball

Playing: When we press SPACE to launch the ball

Game over: When we lose all of our lives

Won: When we destroy all the bricks

Sequence of Events
The game begins in `Ball in paddle` state, the ball is glued to the paddle. 
We can move the paddle and when we do so the ball follows the paddle. When
we press SPACE the games goes into `Playing` state. In this state the ball 
travels across the screen bouncing off the screen borders, bricks and paddle.
If we lose a ball then we go back to `Ball in paddle` state, if we lose all
of our live we enter `Game over` state. If we have destroyed all the bricks
then we go to `Won` state.

Web reference: http://codentronix.com/2011/04/14/game-programming-with-python-and-pygame-making-breakout/
