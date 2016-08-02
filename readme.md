# Bert
An algorithm built to play *Super Street Fighter II* for the *Super Nintendo Entertainment System*.

# Installation
Bert plays on the BizHawk emulator ([Version 1.11.3](http://tasvideos.org/BizHawk.html)), running *Super Street Fighter II: The New Challengers* (US release).
To run Bert on Bizhawk, drag the `main.lua` file onto the BizHawk window. Alternatively, open the Lua Console (Tools > Lua Console) and Open Script (Script > Open Script), then select `main.lua`.
`main.lua` must be in the same directory as `bert.lua`, lest it will not run.
**Note** Bert will be loaded into both player slots, and currently will not properly navigate menus. As such, navigate the game to *SUPER BATTLE* or *VERSUS BATTLE* and select Ryu for the relevant players before running the `main.lua` script. (*Maybe I will supply savestate files to load so users can get straight to the action.*)