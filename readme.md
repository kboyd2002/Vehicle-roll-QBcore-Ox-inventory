# Vehicle Prize System - Complete Documentation

A vehicle case opener system for QBCore servers with ox_inventory integration. Players redeem tickets at an NPC location to spin for a chance to win vehicles with an animated UI.

---

## Features

- Interactive NPC system with qb-target integration
- CSGO-style horizontal spinning animation
- 4-tier rarity system (Legendary, Epic, Rare, Common)
- Weighted probability system for customizable drop rates
- Server-side security and validation
- Automatic database integration
- Ticket-based redemption system
- Support for local images or direct URLs
- Admin commands for ticket distribution
- Unique plate generation
- Anti-spam protection

---

## Requirements

- QBCore Framework
- ox_inventory
- qb-target or ox_target
- oxmysql

---

## Installation

### 1. Download and Setup

Extract the resource to your server's resources folder and rename it to `vehicle_prize_system`.

**File structure:**
```
vehicle_prize_system/
├── fxmanifest.lua
├── config.lua
├── server/
│   ├── main.lua
│   └── commands.lua
├── client/
│   ├── ped.lua
│   └── main.lua
└── html/
    ├── index.html
    ├── style.css
    ├── script.js
    └── images/
```

### 2. Add Item to ox_inventory

Open `ox_inventory/data/items.lua` and add:

```lua
['vehicle_ticket'] = {
    label = 'Vehicle Prize Ticket',
    weight = 10,
    stack = true,
    close = true,
    description = 'Redeem at the prize location for a vehicle.',
    client = {
        image = 'vehicle_ticket.png',
    }
},
```

### 3. Configure Ped Location

Edit `config.lua` line 5:

```lua
Config.PedLocation = {
    coords = vector4(-248.67, -2010.43, 30.14, 233.91), -- Change to your location
    model = 's_m_y_dealer_01',
    scenario = 'WORLD_HUMAN_CLIPBOARD'
}
```

To get coordinates, stand where you want the ped and use `/getcoords` or check F8 console.

### 4. Add to server.cfg

```cfg
ensure vehicle_prize_system
```

### 5. Restart Server

Restart and the script is in Congrats!
---

## Configuration

### Vehicle Prize Pool

Edit `config.lua` starting at line 25. Each vehicle entry requires:

```lua
{
    model = 'adder',           -- Spawn code
    label = 'Truffade Adder',  -- Display name
    weight = 5,                -- Drop chance (higher = more common)
    tier = 'legendary',        -- Rarity tier
    image = 'adder.png'        -- Image filename or URL
}
```

### Probability System

The `weight` value determines drop chance. Example:
- If total weights = 300 and one vehicle has weight 30, it has a 10% chance
- Higher weight = higher chance to win
- Weights do not need to sum to 100

**Example drop rates:**
- Legendary: weight 5 (rare)
- Epic: weight 15 (uncommon)
- Rare: weight 30 (moderate)
- Common: weight 50 (frequent)

### Spin Settings

```lua
Config.SpinDuration = 8000  -- Spin animation time in milliseconds
Config.SpinSpeed = 50       -- Initial speed (lower = faster)
```

### Target System

```lua
Config.UseTarget = 'qb-target'  -- or 'ox_target'
Config.TargetDistance = 2.5
Config.TargetLabel = 'Redeem Vehicle Ticket'
```


---

## How It Works

### Player Flow

1. Player obtains a vehicle ticket (given by admin or earned through gameplay)
2. Player goes to the configured NPC location
3. Player uses qb-target on the NPC
4. Target option only appears if player has a ticket
5. Player clicks "Redeem Vehicle Ticket"
6. Spinning animation plays on screen
7. Server rolls for a vehicle based on weighted probabilities
8. Vehicle is added to player's garage with unique plate
9. Ticket is removed from inventory
10. Player receives notification of their prize

---

## Database Integration

The script automatically inserts vehicles into your QBCore database.

**Default settings:**
- Table: `player_vehicles`
- Garage: `pillboxgarage`
- State: 0 (in garage)

**To change default garage:**

Edit `server/main.lua` line 110:
```lua
'pillboxgarage', -- Change to your desired garage name
```

**Vehicle data stored:**
- License
- Citizen ID
- Vehicle model
- Hash
- Mods (empty by default)
- Plate (auto-generated, unique)
- Garage location
- State (in/out of garage)

---

## Customization

### Add More Vehicles

Edit `config.lua` and add new entries to the `Config.Vehicles` table:

```lua
{
    model = 'your_spawn_code',
    label = 'Display Name',
    weight = 25,
    tier = 'rare',
    image = 'filename.png'
}
```

## Performance Optimization

The script is optimized for minimal performance impact:

- Ped spawns once on resource start
- Target checks use efficient callbacks
- UI only loads when activated
- Images can be lazy-loaded
- Database queries are minimal and optimized
- No unnecessary loops or threads

**Resource usage:**
- Idle: ~0.00ms
- During spin: ~0.01-0.02ms

## Support

For issues or questions:

1. Enable debug mode and check console output
2. Verify all dependencies are installed and updated
3. Check that configuration is correct
4. Review this documentation thoroughly
5. Test with default configuration first

---

## Credits

Created for QBCore Framework with ox_inventory integration.

## License

MIT