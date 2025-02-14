extends Control
class_name GameHUD

@onready var stats_container: MarginContainer = $StatsContainer
@onready var hand_area: Control = $HandArea

func _ready():
	setup_layout()
	# Set anchors to cover full screen
	anchor_left = 0
	anchor_top = 0
	anchor_right = 1
	anchor_bottom = 1
	
	# Remove any offsets
	offset_left = 0
	offset_top = 0
	offset_right = 0
	offset_bottom = 0

func setup_layout():
	# Stats container (top-left)
	var stats_container = create_stats_container()
	add_child(stats_container)
	
	# Hand area (bottom)
	var hand_area = create_hand_area()
	add_child(hand_area)
	
	# Menu button (top-right)
	var menu_button = create_menu_button()
	add_child(menu_button)

func create_stats_container() -> MarginContainer:
	var container = MarginContainer.new()
	container.name = "StatsContainer"
	container.custom_minimum_size = Vector2(200, 100)
	container.anchor_left = 0
	container.anchor_top = 0
	container.offset_left = 20
	container.offset_top = 20
	
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	
	# HP Bar
	var hp_bar = create_resource_bar("HP", Color(0.8, 0.2, 0.2))
	vbox.add_child(hp_bar)
	
	# Mana Bar
	var mana_bar = create_resource_bar("MP", Color(0.2, 0.2, 0.8))
	vbox.add_child(mana_bar)
	
	container.add_child(vbox)
	return container

func create_resource_bar(label_text: String, color: Color) -> HBoxContainer:
	var container = HBoxContainer.new()
	container.add_theme_constant_override("separation", 10)
	
	var label = Label.new()
	label.text = label_text
	label.custom_minimum_size = Vector2(30, 0)
	container.add_child(label)
	
	var progress = ProgressBar.new()
	progress.custom_minimum_size = Vector2(150, 20)
	progress.value = 100
	progress.show_percentage = true
	progress.add_theme_color_override("font_color", color)
	container.add_child(progress)
	
	return container

func create_hand_area() -> Control:
	var area = Control.new()
	area.name = "HandArea"
	area.anchor_left = 0
	area.anchor_right = 1
	area.anchor_top = 1
	area.anchor_bottom = 1
	area.offset_top = -200
	
	var panel = Panel.new()
	panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	panel.add_theme_stylebox_override("panel", load("res://resources/ui_theme.tres").get_stylebox("normal", "Panel"))
	area.add_child(panel)
	
	return area

func create_menu_button() -> Button:
	var button = Button.new()
	button.text = "Menu"
	button.anchor_left = 1
	button.anchor_right = 1
	button.offset_left = -100
	button.offset_right = -20
	button.offset_top = 20
	button.custom_minimum_size = Vector2(80, 30)
	return button
