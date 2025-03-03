Here’s a shorter, simpler README for your FPSCombo cheat system, tailored for a basic, general-purpose Roblox FPS cheat. It’s concise, user-friendly, and focused on the essentials, avoiding overly technical details while maintaining clarity for Roblox exploit users. This README is ideal for your GitHub repo (`https://github.com/LxckStxp/FPSCombo`) and reflects the lightweight, client-side nature of your project.

---

# FPSCombo - Simple Roblox FPS Cheat

A lightweight, client-side cheat for Roblox FPS games, featuring player ESP, instant aimbot, and a middle-click utility. Perfect for quick use in any Roblox FPS game!

## Overview
FPSCombo provides:
- **Player ESP**: Highlights players with team colors (blue for allies, red for enemies) and health bars.
- **Instant Aimbot**: Locks onto enemy players’ heads instantly while holding RightClick.
- **Middle-Click Utility**: Teleports non-player items below the map for 10 seconds, then returns them.

It’s simple, fast, and works client-side to avoid detection in most games.

## Features
- Player ESP with team colors and health bars (up to 1000 studs, fading at distance).
- Overpowered aimbot targeting enemies on RightClick, toggleable via UI.
- Middle-click to hide objects below the map temporarily, toggleable via UI.
- Sleek UI with CensuraDev for easy toggling (ESP, aimbot, team check, middle-click, max distance).

## Installation
1. Clone or download this repo from `https://github.com/LxckStxp/FPSCombo`.
2. Host files on GitHub at `https://raw.githubusercontent.com/LxckStxp/FPSCombo/main/modules/`.
3. Copy this loadstring and paste it into your Roblox executor (e.g., Synapse X, Krnl):
   ```lua
   loadstring(game:HttpGet("https://raw.githubusercontent.com/LxckStxp/FPSCombo/main/main.lua"))()
   ```
4. Inject in any Roblox FPS game and open the UI with RightAlt (default).

## Usage
- **ESP**: Toggle "ESP Enable" to show/hide players. Use "Team Check" for allies (blue) vs. enemies (red).
- **Aimbot**: Hold RightClick to aim at enemies instantly. Toggle via UI.
- **Middle-Click**: Middle-click objects (not players) to teleport them below the map for 10 seconds. Toggle via UI.
- **Adjust Distance**: Slide "Max Distance" (100–2000 studs) for ESP range.

Keep it client-side—don’t modify server data to avoid bans!

## Compatibility
Works in any Roblox FPS game with player characters and team systems. Compatible with Synapse X, Krnl, Fluxus, and other executors supporting `loadstring` and HTTP.

## Safety
- Client-side only—safe if used responsibly.
- Instant aimbot and middle-click may risk detection in some games. Use cautiously and monitor for bans.
- No warranties—use at your own risk.

## Loadstring
Inject FPSCombo with this single line in your executor:
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/LxckStxp/FPSCombo/main/main.lua"))()
```
