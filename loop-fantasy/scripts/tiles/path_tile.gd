extends Node2D
class_name PathTile

var tile_type: String = "basic"
var effects = {}

func _ready():
    _create_visual()

func _create_visual():
    var tile = ColorRect.new()
    tile.size = Vector2(64, 64)
    tile.position = Vector2(-32, -32)
    tile.color = Color(0.2, 0.2, 0.2, 0.5)
    add_child(tile)

func apply_effects(hero: Hero):
    match tile_type:
        "healing":
            hero.heal(5)
        "damage":
            hero.take_damage(3)
        "speed":
            hero.movement_speed *= 1.5