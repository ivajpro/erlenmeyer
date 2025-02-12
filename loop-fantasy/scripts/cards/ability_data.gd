extends Node

const ABILITIES = {
    "slash": {
        "type": "attack",
        "name": "Slash",
        "description": "Deal 5 damage to an enemy",
        "mana_cost": 1,
        "cooldown": 0
    },
    "shield": {
        "type": "defense",
        "name": "Shield Block",
        "description": "Gain 5 armor until next turn",
        "mana_cost": 2,
        "cooldown": 1
    },
    "heal": {
        "type": "heal",
        "name": "Quick Heal",
        "description": "Restore 8 health points",
        "mana_cost": 2,
        "cooldown": 2
    },
    "sprint": {
        "type": "utility",
        "name": "Sprint",
        "description": "Increase movement speed by 50% for this loop",
        "mana_cost": 1,
        "cooldown": 3
    }
}