Config = {}

-- Ped Configuration
Config.PedLocation = {
    coords = vector4(-36.7743, -1110.8297, 26.2423, 64.8077), -- CHANGE THIS to your desired location
    model = 's_m_y_dealer_01', -- Ped model
    scenario = 'WORLD_HUMAN_CLIPBOARD' -- Animation/scenario for the ped
}

-- Ticket Item Name (must match ox_inventory item name)
Config.TicketItem = 'vehicle_ticket'

-- Target Settings
Config.UseTarget = 'qb-target' -- 'qb-target' or 'ox_target'
Config.TargetDistance = 2.5
Config.TargetLabel = 'Redeem Vehicle Ticket'
Config.TargetIcon = 'fas fa-ticket-alt'

-- Spin Animation Settings
Config.SpinDuration = 8000 -- Duration of spin animation in milliseconds (8 seconds)
Config.SpinSpeed = 50 -- Initial speed (lower = faster)

-- Vehicle Prize Pool
-- Weight: Higher number = higher chance (doesn't need to add up to 100)
Config.Vehicles = {
    -- Legendary Tier (Rare)
    {
        model = 'adder',
        label = 'Truffade Adder',
        weight = 5,
        tier = 'legendary',
        image = 'adder.png' -- Place images in html/images/ folder
    },
    {
        model = 't20',
        label = 'Progen T20',
        weight = 5,
        tier = 'legendary',
        image = 't20.png'
    },
    {
        model = 'zentorno',
        label = 'Pegassi Zentorno',
        weight = 5,
        tier = 'legendary',
        image = 'zentorno.png'
    },
    
    -- Epic Tier
    {
        model = 'carbonrs',
        label = 'Nagasaki Carbon RS',
        weight = 15,
        tier = 'epic',
        image = 'carbonrs.png'
    },
    {
        model = 'bati',
        label = 'Pegassi Bati 801',
        weight = 15,
        tier = 'epic',
        image = 'bati.png'
    },
    {
        model = 'coquette',
        label = 'Invetero Coquette',
        weight = 15,
        tier = 'epic',
        image = 'coquette.png'
    },
    
    -- Rare Tier
    {
        model = 'sultan',
        label = 'Karin Sultan',
        weight = 30,
        tier = 'rare',
        image = 'sultan.png'
    },
    {
        model = 'elegy',
        label = 'Annis Elegy RH8',
        weight = 30,
        tier = 'rare',
        image = 'elegy.png'
    },
    {
        model = 'futo',
        label = 'Karin Futo',
        weight = 30,
        tier = 'rare',
        image = 'futo.png'
    },
    
    -- Common Tier
    {
        model = 'blista',
        label = 'Dinka Blista',
        weight = 50,
        tier = 'common',
        image = 'blista.png'
    },
    {
        model = 'dilettante',
        label = 'Karin Dilettante',
        weight = 50,
        tier = 'common',
        image = 'dilettante.png'
    },
    {
        model = 'issi2',
        label = 'Weeny Issi',
        weight = 50,
        tier = 'common',
        image = 'issi2.png'
    },
}

-- Tier Colors (for UI)
Config.TierColors = {
    legendary = '#FFD700', -- Gold
    epic = '#9D4EDD', -- Purple
    rare = '#3A86FF', -- Blue
    common = '#8D99AE' -- Gray
}

-- Notification Settings
Config.Notifications = {
    noTicket = 'You don\'t have a vehicle ticket!',
    rolling = 'Rolling for your vehicle...',
    won = 'Congratulations! You won a %s!',
    error = 'Something went wrong. Please contact an administrator.',
    vehicleInGarage = 'Your new vehicle has been added to your garage!'
}

-- Debug Mode (prints to console)
Config.Debug = false