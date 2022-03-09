# TestNet address : 
https://explorer.pops.one/address/0x9f254688036045eb969bbf9291f853eca857fe5e?activeTab=0

For the following game users can place bet and the owner has the option to Play all the bets
in the pool.
Every user is given 100 points in the start for free and on winning they double their amount and 
on losing they receive none.
Code is checked to prevent multiple transactions, betting lower/higher than current balance transactions, and a harmony vrf is used for random number generation.

Example scenario:
Event NewBet shows 3 parameters user(address), amount(amount he better), coin choice(heads/tails)

Player 1 bets 50 points on Heads
![p1 bet](https://user-images.githubusercontent.com/72071559/157492453-ed498259-1786-4adb-9493-06c0c31e8336.jpg)

Player 2 bets 60 points on Tails
![p2 bet](https://user-images.githubusercontent.com/72071559/157492466-2c3c6d0d-6fda-47c1-b9a6-645411df9e91.jpg)

Player1 loses -50 and Player2 wins +60
Event Result shows 3 parameters user(address), amountWon(amount he won/lost this round), currentBalance(after transaction balance)
![transfer](https://user-images.githubusercontent.com/72071559/157492476-82918f98-b220-4914-a5dd-2b0fc814cc49.jpg)


![testnet](https://user-images.githubusercontent.com/72071559/157495154-ad578880-b725-41f5-97b2-e8acf58243a9.jpg)
