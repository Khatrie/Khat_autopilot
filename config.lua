Config = {}
Config.NormalSpeed = 35.0 / 1.6 -- Normal Speed
Config.NormalDrive = 786603 -- Normal Drive Style
Config.CrazySpeed = 150.0 / 1.6 -- Crazy Speed
Config.CrazyDrive = 1074528293 -- Crazy Drive Style
Config.StartCommand = "ap" -- Command to activate Auto-Pilot
--Default normal autopilot: /autopilot normal

Config.StopCommand = "apstop" -- Command to disable Auto-Pilot

Config.Translate = {
    [1] = "Autopilot - Activated",
    [2] = "You have not set a waypoint!",
    [3] = "You are not in a vehicle!",
    [4] = "Autopilot - Disabled",
    [5] = "Autopilot Normal - Button Pressed",
    [6] = "Autopilot Aggressive - Button Pressed",
    [7] = "Destination Reached, Autopilot Disabled.",
    [8] = "Not An Electric Vehicle",
    [9] = "Manual Override Detected.",
    [10] = "Accident Detected, Autopilot Disabled!",
    [11] = "Accident Reported!",
    [12] = "Approaching Destination, Brakes will Automatically Apply.",
}

Config.APVehicles = {
    'raiden',
    'voltic',
    'neon',
    'cyclone',
    'virtue',
    'omnisegt',
    'cyclone2',
    'dilettante',
    'dilettante2'
}
