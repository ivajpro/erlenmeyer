extends Node2D
class_name HandManager

# Add this line at the top to ensure Card class is loaded
const CardScene = preload("res://scripts/cards/card.gd")

var card_scene = preload("res://scenes/cards/card.tscn")
var max_cards: int = 5
var cards: Array = []
var card_types = ["basic", "healing", "damage", "speed"]
var selected_card: Card = null

func _ready():
	draw_initial_hand()

func draw_initial_hand():
	for i in range(max_cards):
		draw_card()

func draw_card():
	if cards.size() >= max_cards:
		return
		
	var card: Card = card_scene.instantiate() as Card
	if card:
		 # Calculate card positions to center them at bottom
		var viewport_size = get_viewport_rect().size
		var total_width = (cards.size() + 1) * 120  # 120 is card spacing
		var start_x = (viewport_size.x - total_width) / 2
		var card_x = start_x + (120 * cards.size())
		var card_y = viewport_size.y - 150  # 150 pixels from bottom
		
		card.tile_type = card_types[randi() % card_types.size()]
		card.card_name = card.tile_type.capitalize() + " Tile"
		card.position = Vector2(card_x, card_y)
		
		# Connect signals using new syntax
		card.mouse_entered.connect(_on_card_mouse_entered)
		card.mouse_exited.connect(_on_card_mouse_exited)
		card.card_selected.connect(select_card)  # Connect to new signal
		
		cards.append(card)
		add_child(card)

func select_card(card: Card):
	print("Selecting card: ", card.card_name)  # Debug print
	if selected_card and selected_card != card:
		selected_card.is_selected = false
	
	if selected_card == card:
		card.is_selected = !card.is_selected  # Toggle selection
		if !card.is_selected:
			selected_card = null
	else:
		card.is_selected = true
		selected_card = card
	
	print("Selected card is now: ", selected_card.card_name if selected_card else "None")  # Debug print

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if selected_card:
			_on_card_played(selected_card.tile_type, get_global_mouse_position())
			selected_card.is_selected = false
			selected_card = null

func _on_card_played(tile_type: String, target_position: Vector2):
	get_parent().try_place_tile(tile_type, target_position)
	var card_index = cards.find(selected_card)
	if card_index != -1:
		var card = cards[card_index]
		cards.remove_at(card_index)
		card.queue_free()
		draw_card()

func _on_card_mouse_entered(card: Card):
	if card:
		card.is_hovered = true
		print("Card hovered: ", card.card_name)  # Debug print

func _on_card_mouse_exited(card: Card):
	if card:
		card.is_hovered = false
		if card != selected_card:
			print("Card unhovered: ", card.card_name)  # Debug print
