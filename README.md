# Tower Clash
A 2D puzzle tower game built with **Godot Engine** using **GDScript**.

---

## Overview
**Tower Clash** is a fast-paced 2D puzzle game inspired by **2048** and **Tetris**, where the player drops numbered blocks to merge equal values and reach a **random winning target** within **3 minutes**.

Your goal: Merge smartly before the timer runs out. Once your tower reaches the target number, you win!

---

## Gameplay Rules
- Blocks spawn at the top with numbers like `2, 4, 8, 16`, etc.  
- Press **Space** (or **Down Arrow**) to drop a block.  
- When two blocks of the same number collide, they **merge and double**.  
- Win by reaching the **target number** before the **3-minute timer** ends.  
- If the tower exceeds the height limit or time runs out, **Game Over**.

---

## Game Settings
- **Winning Target:** Randomized between `128–512` each round.  
- **Time Limit:** `3 minutes (180 seconds)` per round.  
- **Game Over Conditions:**
  - Timer reaches 0  
  - Tower exceeds height limit  
  - Player hits the winning target  

---

### Randomize Winning Target
```gdscript
var target_value: int

func _ready():
    randomize()
    target_value = randi_range(128, 512)
    print("Target for this round:", target_value)
