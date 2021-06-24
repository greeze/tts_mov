local encounters = {
  hazards = {
    blue = { 10, 10, 20, 20, 30, 30, 40 },
    red = { 10, 20, 20, 30, 30, 40 },
    yellow = { 10, 20, 30, 40 }
  },
  relics = {
    {
      name = "Air Foil",
      value = 80,
      description = "Land and take off for 1 movement cost (instead of 2). Travel between surface cities for 1 movement cost."
    },
    {
      name = "Auto Pilot",
      value = 80,
      description = "Set one die to 4 before rolling for speed."
    },
    {
      name = "Gate Lock",
      value = 100,
      description = "Treat any telegate as a blue space."
    },
    {
      name = "Jump Start",
      value = 120,
      description = "House rule: When choosing a navigation die, optionally jump to the same-numbered telegate before moving. (See instructions for original rule.)"
    },
    {
      name = "Mulligan Gear",
      value = 120,
      description = "House rule: Optionally reroll one die after rolling for speed. (See instructions for original rule.)"
    },
    {
      name = "Shield",
      value = 60,
      description = "Identical to purchasable shield equipment, but occupies no space on a ship."
    },
    {
      name = "Spy Eye",
      value = 100,
      description = "House rule: May sneak a peak at an encounter token before choosing to ignore it by leaving it face down, or accept it by turning it face up. May observe a culture from anywhere within its system, rather than just in orbit. (See instructions for original rule.)"
    },
    {
      name = "Switch Switch",
      value = 100,
      description = "Optionally switch navigation die with another speed die as often as desired anytime during a turn."
    },
    {
      name = "Yellow Drive",
      value = 80,
      description = "Identical to purchasable yellow drive equipment, but occupies no space on a ship."
    }
  },
  spaceports = 3,
  telegates = { 1, 2, 3, 4, 5, 6 }
}

return encounters
