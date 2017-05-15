# Bert

An algorithm built to play *Super Street Fighter II* for the *Super Nintendo Entertainment System*.

## Motivation

Bert exists in order to supplement another, more dynamic artifical fighting game player, to act as a 'training dummy' of sorts in helping the fitness of a genetic algorithm. Thus its goals are to act in a way that is as close to a human player as possible, making decisions with human reaction times, rather than playing the game optimally (a comparatively simple task).

## Installation

Bert plays on the BizHawk emulator ([Version 1.12.2](http://tasvideos.org/BizHawk.html)), running *Super Street Fighter II: The New Challengers* (US release).  

To run Bert on Bizhawk, drag the `main.lua` file onto the BizHawk window. Alternatively, open the Lua Console (Tools > Lua Console) and Open Script (Script > Open Script), then select `main.lua`.  
`main.lua` must be in the same directory as `bert.lua`, lest it will not run.  

**Note** Bert will be loaded into both player slots, and currently will not properly navigate menus. As such, navigate the game to *SUPER BATTLE* or *VERSUS BATTLE* and select Ryu for the relevant players before running the `main.lua` script. (*Maybe I will supply savestate files to load so users can get straight to the action.*)

## How it works

This algorithm looks at the memory addresses of BizHawk as input, information about those memory addresses can be found in [this Google sheet](https://docs.google.com/spreadsheets/d/1j9otcEO9si3i59zi-tBLc_kEkg3A1DVr2p1LAXbqkO0/edit?usp=sharing). The lua scripts make the decisions for *Ryu* (the *Street Fighter II* main character), and affects the state of one of the player controllers of the BizHawk emulator. This is the only way that the algorithm affects the game state.  

*UML to come*