// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract Coinflip{

    address public owner;
    //default constructor to create an instance
    constructor() {
        owner = msg.sender;
    }
    /* structure to hold information of a bet with the user's address, amount he betted and the 
    coin he chose(0 or 1) referring to head or tails*/ 
    struct Bet{
        address user;
        uint amount;
        uint coinChoice;
    }
    //dynamic array to store bets
    Bet[] private bets;

    /* structure to hold Status of a user like what is his current balance, is he already playing, 
        if he a newuser(then grant him free 100 points)*/
    struct Status{
        uint balance;
        bool playing;
        bool newUser;
    }
    // maps the user to his Status
    mapping(address => Status) userStatus;

    //modifier to allow operations for the owner
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    //modifier to allow operations for everyone except the owner
    modifier notOwner() {
        require(msg.sender != owner);
        _;
    }

    // Event which shows the information about the user address, amount he betted, and the coin he chose
    event NewBet(
        address user, uint amount, uint coinChoice
    );

    /* Event which is fired at the time of rewarding which shows the information about the user address, amount he 
        won/lost in the current bet and his current balance */
    event Result(
        address user, int amountWon, uint currentBalance
    );

    /*  Allows user to bet with the amount and his coin choice
        params amount: the amount the user betted with
        params choice: the coin choice the choosed
    */
    function PlaceBet(uint amount, uint choice) external payable notOwner {
        // If the user is new he is granted 100 points 
        if(userStatus[msg.sender].newUser == false){    
            userStatus[msg.sender].balance = 100;
            userStatus[msg.sender].newUser = true;
        }
        // Checking if the current user balance is greater than the amount he betted
        require(userStatus[msg.sender].balance >= amount, "Insufficient balance");
        // Checking if the user is currently in a bet or not
        require(userStatus[msg.sender].playing == false, "Cannot play multiple bets at the same time");
        // Checking if the choice is 0 or 1 
        require(choice < 2, "Only accepts 0 or 1 for heads/tails");

        //1.Deduce the amount he betted 
        //2.Set the user as currently playing 
        //3.Fire an event that contains information about the new bet
        //4.Push the bet in the current betting pool
        userStatus[msg.sender].balance -= amount;
        userStatus[msg.sender].playing = true;
        emit NewBet(msg.sender, amount, choice);
        bets.push(Bet(msg.sender, amount, choice));
    }

    // function showBets() private view returns(Bet[] memory) {
    //     return bets;
    // }

    // A function which can be used by the owner to conclude all the bets
    function Roll() public onlyOwner returns(bool){
        rewardBets();
        return true;
    }
    // Function to conclude all the bets and clear the betting pool
    function rewardBets() private onlyOwner {
        uint coin = uint(vrf()) % 2;      //Result of random function
        for(uint i=0;i<bets.length;i++){
            int prize;
            // Add double of the amount to the balance if the user wins
            if((coin == 0 && bets[i].coinChoice == 1) || (coin == 1 && bets[i].coinChoice == 0)){   
                userStatus[bets[i].user].balance += 2*bets[i].amount;
                prize = int(bets[i].amount);
            }
            else{
                prize = -int(bets[i].amount);
            }
            // Fire an event cotaining user address, amount he won/lost in current bet, current balance
            emit Result(bets[i].user, prize, userStatus[bets[i].user].balance);
        }
        uint n = bets.length;
        for(uint i=0;i<n;i++){
            // Set user as not playing after the pool is concluded and clear the betting pool
            userStatus[bets[n-1-i].user].playing = false;
            bets.pop();
        }
    }

      function vrf() public view returns (bytes32 result) {
        uint[1] memory bn;
        bn[0] = block.number;
        assembly {
            let memPtr := mload(0x40)
            if iszero(staticcall(not(0), 0xff, bn, 0x20, memPtr, 0x20)) {
                invalid()
            }
            result := mload(memPtr)
        }
    }
}
