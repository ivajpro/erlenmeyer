extends Node2D
class_name Card

# Signal declarations
signal mouse_entered(card: Card)
signal mouse_exited(card: Card)
signal card_selected(card: Card)

@export var ability_type: String = "attack":
	set(value):
		ability_type = value
		_update_card_style()

@export var card_name: String = "Basic Attack"
@export var description: String = "Deal 5 damage to an enemy"
@export var mana_cost: int = 1
@export var cooldown: int = 0

var is_selected: bool = false
var is_hovered: bool = false
var card_colors = {
	"attack": Color(0.6, 0.2, 0.2),  # Red for damage
	"defense": Color(0.2, 0.4, 0.6),  # Blue for protection
	"heal": Color(0.2, 0.6, 0.3),     # Green for healing
	"utility": Color(0.6, 0.4, 0.2)   # Orange for utility
}

func _ready():
	_create_visual()
	_setup_area()

func _create_visual():
	# Container for all card elements
	var container = Control.new()
	container.name = "CardContainer"
	add_child(container)
	
	# Drop shadow
	var shadow = ColorRect.new()
	shadow.name = "Shadow"
	shadow.size = Vector2(110, 160)
	shadow.position = Vector2(-55 + 3, -80 + 3)
	shadow.color = Color(0, 0, 0, 0.4)
	shadow.z_index = -2
	container.add_child(shadow)
	
	# Card border
	var border = ColorRect.new()
	border.name = "Border"
	border.size = Vector2(104, 154)
	border.position = Vector2(-52, -77)
	border.color = Color(0.4, 0.4, 0.4, 1.0)
	container.add_child(border)
	
	# Main background with ability color
	var bg_rect = ColorRect.new()
	bg_rect.name = "Background"
	bg_rect.size = Vector2(100, 150)
	bg_rect.position = Vector2(-50, -75)
	bg_rect.color = card_colors[ability_type]
	container.add_child(bg_rect)
	
	# Cost circle in top-left
	var cost_bg = ColorRect.new()
	cost_bg.name = "CostBg"
	cost_bg.size = Vector2(25, 25)
	cost_bg.position = Vector2(-45, -70)
	cost_bg.color = Color(0.1, 0.1, 0.1, 0.5)
	container.add_child(cost_bg)
	
	var cost_label = Label.new()
	cost_label.name = "CostLabel"
	cost_label.text = str(mana_cost)
	cost_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	cost_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	cost_label.position = cost_bg.position
	cost_label.size = cost_bg.size
	cost_label.add_theme_font_size_override("font_size", 16)
	container.add_child(cost_label)
	
	# Card name
	var title = Label.new()
	title.name = "Title"
	title.text = card_name.to_upper()
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.position = Vector2(-45, -40)
	title.size = Vector2(90, 25)
	title.add_theme_font_size_override("font_size", 14)
	container.add_child(title)
	
	# Description text
	var desc = Label.new()
	desc.name = "Description"
	desc.text = description
	desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	desc.position = Vector2(-45, -10)
	desc.size = Vector2(90, 60)
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD
	desc.add_theme_font_size_override("font_size", 12)
	container.add_child(desc)
	
	# Cooldown indicator (if any)
	if cooldown > 0:
		var cd_label = Label.new()
		cd_label.name = "CooldownLabel"
		cd_label.text = "CD: " + str(cooldown)
		cd_label.position = Vector2(15, -70)
		cd_label.add_theme_font_size_override("font_size", 12)
		container.add_child(cd_label)

func _setup_area():
	var area = Area2D.new()
	area.name = "CardArea"
	area.input_pickable = true
	
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(100, 150)
	collision.shape = shape
	collision.position = Vector2(0, 0)
	
	area.add_child(collision)
	add_child(area)
	
	area.mouse_entered.connect(_on_mouse_enter)
	area.mouse_exited.connect(_on_mouse_exit)
	area.input_event.connect(_input_event)

func _process(_delta):
	_update_visual_state()

func _update_visual_state():
	if not is_instance_valid(self):
		return
		
	var tween = create_tween()
	
	if is_selected:
		tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.15)
		tween.parallel().tween_property(self, "rotation_degrees", -5, 0.15)
		tween.parallel().tween_property(self, "modulate", Color(1.2, 1.2, 1.4), 0.15)
	elif is_hovered:
		tween.tween_property(self, "scale", Vector2(1.05, 1.05), 0.15)
		tween.parallel().tween_property(self, "rotation_degrees", -2, 0.15)
		tween.parallel().tween_property(self, "modulate", Color(1.1, 1.1, 1.2), 0.15)
	else:
		tween.tween_property(self, "scale", Vector2(1, 1), 0.15)
		tween.parallel().tween_property(self, "rotation_degrees", 0, 0.15)
		tween.parallel().tween_property(self, "modulate", Color(1, 1, 1), 0.15)

func _update_card_style():
	var bg = get_node_or_null("CardContainer/Background")
	var header = get_node_or_null("CardContainer/Header")
	if bg and header:
		bg.color = card_colors[ability_type]
		header.color = card_colors[ability_type].lightened(0.1)

func _on_mouse_enter():
	is_hovered = true
	mouse_entered.emit(self)

func _on_mouse_exit():
	is_hovered = false
	mouse_exited.emit(self)

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		card_selected.emit(self)
