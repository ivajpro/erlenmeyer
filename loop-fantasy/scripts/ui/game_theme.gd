extends Theme
class_name GameTheme

func _init():
    # Panel styling
    var panel_style = StyleBoxFlat.new()
    panel_style.bg_color = Color(0.1, 0.1, 0.1, 0.9)
    panel_style.border_width_left = 2
    panel_style.border_width_top = 2
    panel_style.border_width_right = 2
    panel_style.border_width_bottom = 2
    panel_style.border_color = Color(0.3, 0.3, 0.3, 1.0)
    panel_style.corner_radius_top_left = 8
    panel_style.corner_radius_top_right = 8
    panel_style.corner_radius_bottom_right = 8
    panel_style.corner_radius_bottom_left = 8
    
    set_stylebox("panel", "Panel", panel_style)
    
    # Button styling
    var button_normal = StyleBoxFlat.new()
    button_normal.bg_color = Color(0.2, 0.2, 0.2, 1.0)
    button_normal.border_width_left = 2
    button_normal.border_width_top = 2
    button_normal.border_width_right = 2
    button_normal.border_width_bottom = 2
    button_normal.corner_radius_top_left = 4
    button_normal.corner_radius_top_right = 4
    button_normal.corner_radius_bottom_right = 4
    button_normal.corner_radius_bottom_left = 4
    
    set_stylebox("normal", "Button", button_normal)