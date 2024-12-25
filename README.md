# 2D Infinite Runner Game on DE10-Lite

## Overview
This project is a 2D infinite runner game where the player controls a character to jump over randomly generated obstacles. Inspired by the Google Chrome dinosaur game, it features real-time scorekeeping, VGA display output, and gameplay controls using the DE10-Lite board's buttons and switches.

## Features
- **Real-time Score Display**: Seven-segment displays show the score in decimal format.
- **Player Controls**:  
  - Jump Button: Triggers the player's jump.  
  - Reset Button: Resets the score or starts a new game.  
  - Pause Switch: Pauses/resumes the game.  
- **Game Elements**:  
  - Player gravity and collision detection.  
  - Randomized obstacle generation (height and delay).  
- **VGA Output**: Smooth 60 FPS display with 640x480 resolution and 4-bit RGB sprites.  
- **Phase Locked Loop (PLL)**: Ensures a 25MHz clock for VGA synchronization.

## Design Approach
1. **Counters**: Designed as ripple carry adders with a decimal system to manage scorekeeping on the seven-segment display.
2. **Game Logic**:  
   - Player and obstacle positions defined within the 640x480 VGA bounds.  
   - Jump physics implemented using registers and bit-shifting for realistic motion.  
   - Collision detection compares player and obstacle coordinates.
3. **VGA Display**:  
   - Static elements: Floor and "Game Over" screen.  
   - Dynamic elements: Player and obstacles with moving coordinates.

## Gameplay Mechanics
- **Starting Position**: Player starts at `x=40, y=460`, with the floor at `y=460`.
- **Obstacle Generation**: Randomly appears at `x=640` with varying heights.
- **Game Over**: Collision detection runs at 10Hz. If collision occurs, the display shows "DED," and the game stops until reset.

## Hardware Utilization
- **DE10-Lite Features Used**:  
  - 7-segment displays for scorekeeping.  
  - Buttons and switches for game control.  
  - Internal clocks for timing mechanisms.  
  - VGA output for game visuals.
