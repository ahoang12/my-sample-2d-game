# Alligator Stack

A simple and relaxing 2D stacking game made with **Godot 4**, where players drop moving blocks to build the tallest tower possible while facing natural forces like wind. The goal is to stack as many blocks as you can before the tower collapses!

---

## Gameplay Overview

Players drop moving blocks from above to create a stable tower.  
Each block swings left and right horizontally and slowly drops down. Press **Space** to drop the block at the right time.

### Features
- **Tower Building Mechanics:** Stack alligator blocks as high as you can.  
- **Obstacle (Dynamic Wind System):** Wind gusts trigger randomly every few seconds, slightly pushing your tower and testing your balance.  
- **Adaptive Camera:** Smoothly follows your tower as it grows taller.  
- **Game Over Detection:** The game ends when your tower collapses or falls off-screen.  
- **Score System:** Score = number of successfully stacked blocks before the game is over.  

---

## Design Goals

- **Simplicity:** Easy to learn, one-button control.
- **Challenge:** Players must drop blocks with good timing and positioning.
- **Replayability:** Random wind events and varied block speeds ensure no two runs are the same.

---

## Inspirations

The game is inspired by:
- *Tetris* — for its stacking and precision mechanics.  
- *Jenga* — for the balance and tension aspect.  
- *Tower Builder* (mobile) — for the satisfying feeling of dropping blocks.

---

## Development Process

- Built in **Godot 4**.
- Uses **GDScript** for physics and logic.
- Assets are mostly procedural and simple 2D shapes (Rectangles, RigidBody2D).
- UI and effects (wind warnings, game over).

### Team Roles
| Member | Focus |
|--------|--------|
| Anh + John | Core gameplay logic (block spawning, camera, physics) |
| Anh + John | Obstacle systems (wind, earthquake, rain) |
| Kareena | UI, sound design, and art assets |

---

## How to Play

1. Run the game in Godot.  
2. Press **Space** to drop the falling alligator.  
3. Try to stack as many as you can without tipping the tower.  
4. When the tower falls, it’s game over!  
