extends Node2D
class_name Card

signal card_played(tile_type: String, position: Vector2)

var tile_type: String = "basic"
var card_name: String = "Basic Tile"
var description: String = "A basic path tile"

func _ready():
    _create_visual()
    
func _create_visual():
    var background = ColorRect.new()
    background.size = Vector2(100, 150)
    background.position = Vector2(-50, -75)
    background.color = Color(0.2, 0.2, 0.2)
    add_child(background)
    
    var label = Label.new()
    label.text = card_name
    label.position = Vector2(-40, -65)
    add_child(label)

func _input_event(_viewport, event, _shape_idx):
    if event is InputEventMouseButton and event.pressed:
        emit_signal("card_played", tile_type, get_global_mouse_position())