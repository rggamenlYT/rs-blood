rs-blood is a comprehensive blood sampling system for FiveM servers using QBCore and ox_inventory. It enables immersive medical roleplay by allowing EMS players to draw blood from other players, automatically manage blood types, and handle blood bags as inventory items with detailed metadata.

Features
/takeblood Command:
Only players with the ambulance job can use /takeblood to draw blood from the nearest player (or themselves in debug mode).

Blood Bag Creation:
When blood is taken, a blood bag item is added to the EMS player’s inventory. The item includes metadata such as the blood type, first name, and last name of the patient.

Automatic Blood Type Assignment & Storage:
If a player does not yet have a blood type, the script randomly assigns one (from types listed in the config) and stores it in a dedicated database table, along with the player’s Steam name, character name, and the date/time of creation.

Configurable Blood Types:
All possible blood types are configured in the script’s config file.

Discord Logging:
Every blood draw is logged to a configurable Discord webhook, including the blood type, patient’s character name, Steam name, and timestamp.

Medical Animation & Progress Bar:
The EMS player performs a medical animation and a configurable progress bar is shown during the blood draw.

Health Effects:
The patient loses a small configurable amount of HP. There are also configurable chances for the patient to become dizzy (drunk effect) or to briefly collapse (ragdoll).

Item Requirements:
The EMS player must have a needle and an empty blood bag in their inventory to perform the procedure.

Needle Item Usage (Configurable):
Optionally, the blood draw can be started by using the needle item directly from the inventory, instead of typing the command.

Debug Mode:
Allows testing the blood draw on yourself.

Fully Configurable:
All key features, chances, effects, Discord webhook, and item requirements can be adjusted in the config file.

How It Works
EMS player uses /takeblood (or the needle item, if enabled).

The script checks for required items and the nearest player.

If the patient has no blood type, one is assigned and saved in the database.

The EMS player performs an animation and a progress bar is shown.

After completion:

A blood bag with the patient’s name and blood type is added to the EMS inventory.

The patient loses HP and may get dizzy or collapse.

A log is sent to Discord.

All blood bag items display patient info and blood type in ox_inventory, using metadata.

Requirements
QBCore Framework

ox_inventory

oxmysql (for database storage)

Discord webhook (for logging)

Configuration
All blood types, item names, effect chances, and Discord settings are found in config.lua.

The needle item usage feature can be toggled on or off via the config.

Installation
Place the rs-blood folder in your server’s resources directory.

Add ensure rs-blood to your server.cfg.

Import the provided SQL to create the player_bloodtypes table.

Add the required items to your ox_inventory items file.

Adjust config.lua as needed for your server.

Restart your server.

Customization
Blood types and all gameplay effects are easily adjustable in the config.

The script is modular and can be extended for further medical RP features.

