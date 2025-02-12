extends Control
class_name ActionMenu

signal action_selected(action: String)

func _ready():
    hide()
    _setup_menu()

func _setup_menu():
    # Create background panel
    var panel = Panel.new()
    panel.set_anchors_preset(Control.PRESET_CENTER)
    panel.position = Vector2(-150, -100)
    panel.size = Vector2(300, 200)
    panel.theme = GameTheme.new()
    
    # Create container for buttons
    var vbox = VBoxContainer.new()
    vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
    vbox.add_theme_constant_override("separation", 10)
    vbox.add_theme_constant_override("margin_left", 20)
    vbox.add_theme_constant_override("margin_right", 20)
    vbox.add_theme_constant_override("margin_top", 20)
    vbox.add_theme_constant_override("margin_bottom", 20)
    
    # Add title
    var title = Label.new()
    title.text = "Loop Complete!"
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 24)
    vbox.add_child(title)
    
    # Add spacer
    var spacer = Control.new()
    spacer.custom_minimum_size = Vector2(0, 10)
    vbox.add_child(spacer)
    
    # Create buttons
    _add_button(vbox, "Place Tiles", "place_tile")
    _add_button(vbox, "Manage Equipment", "equip")
    _add_button(vbox, "Continue Journey", "continue")
    
    panel.add_child(vbox)
    add_child(panel)

func _add_button(container: Container, text: String, action: String):
    var button = Button.new()
    button.text = text
    button.custom_minimum_size = Vector2(0, 40)
    button.pressed.connect(func(): action_selected.emit(action))
    container.add_child(button)