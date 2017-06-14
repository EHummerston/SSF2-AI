# Super Street Fighter II Artificial Intelligence Framework

A framework for building algorithms to play *Super Street Fighter II* for the *Super Nintendo Entertainment System*.

## Motivation

This framework was created to facilitate the ability for multiple people to create algorithms to play fighting games against each other. Additionally, the project aims to enable more complicated Artificial Intelligence concepts such as genetic algorithms (inspired in part by [MarI/O](https://youtu.be/qv6UVOQ0F44))

*Super Street Fighter II* was chosen for several reasons:

* The technical simplicity of the game.
* It can be emulated on the BizHawk emulator, which itself has good coding support.
* Its high-depth, low-complexity gameplay.
* The wide amount of theory on its metagame and systems.

## Installation

The SSF2-AI framework plays on the BizHawk emulator ([Version 1.12.2](http://tasvideos.org/BizHawk.html)), running *Super Street Fighter II: The New Challengers* (US release).

To run an algorithm on Bizhawk, drag the `main.lua` file onto the BizHawk window. Alternatively, open the Lua Console (Tools > Lua Console) and Open Script (Script > Open Script), then select `main.lua`.

For examples of the implementation of the SSF2-AI framework, go to the [SSF2-AI-Demos](https://github.com/EHummerston/SSF2-AI-Demos) repository.

## How to work with it

1. Extend the `Bot` class.
2. Implement the `advance()` function and write out how the algorithm should determine controller inputs for each frame.
3. Reference your own class and call `SFMatch.run()` in a run script.

For examples of the implementation of the SSF2-AI framework, go to the [SSF2-AI-Demos](https://github.com/EHummerston/SSF2-AI-Demos) repository.

## How it works

This algorithm looks at the memory addresses of BizHawk as input, information about those memory addresses can be found in [this Google sheet](https://docs.google.com/spreadsheets/d/1j9otcEO9si3i59zi-tBLc_kEkg3A1DVr2p1LAXbqkO0/edit?usp=sharing). The bot scripts make the decisions for their character, and affects the state of one of the player controllers of the BizHawk emulator accordingly. This is the only way that the algorithms should affect the game state.