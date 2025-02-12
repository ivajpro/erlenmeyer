extends Node2D
class_name Card

# Signal declarations
signal mouse_entered(card: Card)
signal mouse_exited(card: Card)
signal card_selected(card: Card)

@export var tile_type: String = "basic"
@export var card_name: String = "Basic Tile"
@export var description: String = "A basic path tile"

var is_selected: bool = false
var is_hovered: bool = false

@onready var background = $Background
@onready var label = $Label

func _ready():
	_create_visual()
	_setup_area()
	
func _create_visual():
	# Add drop shadow
	var shadow = ColorRect.new()
	shadow.name = "Shadow"
	shadow.size = Vector2(104, 154)
	shadow.position = Vector2(-52 + 2, -77 + 2)
	shadow.color = Color(0, 0, 0, 0.3)
	shadow.z_index = -2
	add_child(shadow)
	
	# Create border with gradient
	var border = ColorRect.new()
	border.name = "Border"
	border.size = Vector2(104, 154)
	border.position = Vector2(-52, -77)
	border.color = Color(0.4, 0.4, 0.4, 1.0)
	add_child(border)
	
	# Create card background
	var bg_rect = ColorRect.new()
	bg_rect.name = "Background"
	bg_rect.size = Vector2(100, 150)
	bg_rect.position = Vector2(-50, -75)
	bg_rect.color = Color(0.2, 0.2, 0.2, 1.0)
	bg_rect.z_index = 0
	add_child(bg_rect)
	
	# Create card frame
	var frame = ColorRect.new()
	frame.name = "Frame"
	frame.size = Vector2(96, 146)
	frame.position = Vector2(-48, -73)
	frame.color = Color(0.3, 0.3, 0.3, 1.0)
	frame.z_index = 1
	add_child(frame)
	
	# Add card name with higher z-index
	var name_label = Label.new()
	name_label.name = "CardLabel"  # Changed name to be more specific
	name_label.text = card_name
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.size = Vector2(90, 30)
	name_label.position = Vector2(-45, -65)
	name_label.add_theme_color_override("font_color", Color.WHITE)
	name_label.z_index = 2
	add_child(name_label)

func _setup_area():
	var area = Area2D.new()
	area.name = "CardArea"
	area.input_pickable = true  # Make sure this is set
	
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(100, 150)
	collision.shape = shape
	collision.position = Vector2(0, 0)
	
	area.add_child(collision)
	add_child(area)
	
	# Connect both mouse and input events
	area.mouse_entered.connect(_on_mouse_enter)
	area.mouse_exited.connect(_on_mouse_exit)
	area.input_event.connect(_input_event)

func _process(_delta):
	var border = get_node_or_null("Border")
	if border:
		if is_selected:
			print("Card is selected: ", card_name)  # Debug print
			border.color = Color(1, 0, 0, 0.8)  # Bright red for selected
			scale = Vector2(1.1, 1.1)  # Make selected card slightly larger
		elif is_hovered:
			border.color = Color(1, 1, 1, 0.5)  # White for hover
			scale = Vector2(1.05, 1.05)  # Slightly larger on hover
		else:
			border.color = Color(0.4, 0.4, 0.4, 0.3)  # Default gray
			scale = Vector2(1.0, 1.0)  # Normal size

func _on_mouse_enter():
	is_hovered = true
	mouse_entered.emit(self)  # Use .emit() syntax

func _on_mouse_exit():
	is_hovered = false
	mouse_exited.emit(self)

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseMotion:
		is_hovered = true
	elif event is InputEventMouseButton and event.pressed:
		print("Card clicked: ", card_name)  # Debug print
		card_selected.emit(self)  # Use new signal instead of direct parent call
