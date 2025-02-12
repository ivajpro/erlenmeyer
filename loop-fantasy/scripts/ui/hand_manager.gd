extends Node2D
class_name HandManager

var card_scene = preload("res://scenes/cards/card.tscn")
var max_cards: int = 5
var cards: Array = []
var card_types = ["basic", "healing", "damage", "speed"]

func _ready():
    draw_initial_hand()

func draw_initial_hand():
    for i in range(max_cards):
        draw_card()

func draw_card():
    if cards.size() >= max_cards:
        return
        
    var card = card_scene.instantiate()
    card.tile_type = card_types[randi() % card_types.size()]
    card.position = Vector2(120 * cards.size() + 100, 500)
    card.connect("card_played", _on_card_played)
    cards.append(card)
    add_child(card)

func _on_card_played(tile_type: String, position: Vector2):
    get_parent().try_place_tile(tile_type, position)
    var card_index = cards.find(get_viewport().get_mouse_position())
    if card_index != -1:
        var card = cards[card_index]
        cards.remove_at(card_index)
        card.queue_free()
        draw_card()