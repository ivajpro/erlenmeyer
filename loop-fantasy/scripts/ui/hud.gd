extends CanvasLayer

var hero: Hero

func _ready():
    # Wait for scene tree to be ready
    await get_tree().process_frame
    _find_hero()
    _create_stats_display()

func _find_hero():
    var hero_node = get_node_or_null("/root/GameLoop/Hero")
    if hero_node:
        hero = hero_node
    else:
        # Retry after a short delay
        await get_tree().create_timer(0.5).timeout
        _find_hero()

func _process(_delta):
    if hero:
        update_stats_display()
    else:
        _find_hero()

func update_stats_display():
    if not hero or not is_instance_valid(hero):
        return
        
    $MarginContainer/StatsContainer/HealthLabel.text = "HP: %d/%d" % [hero.stats.health, hero.stats.max_health]
    $MarginContainer/StatsContainer/LevelLabel.text = "Level: %d" % hero.stats.level
    $MarginContainer/StatsContainer/ExpLabel.text = "EXP: %d/%d" % [hero.stats.experience, hero.stats.next_level]

func _create_stats_display():
    # Main stats container
    var stats_panel = Panel.new()
    stats_panel.set_anchors_preset(Control.PRESET_TOP_LEFT)
    stats_panel.position = Vector2(20, 20)
    stats_panel.size = Vector2(250, 150)
    
    var stats_container = VBoxContainer.new()
    stats_container.set_anchors_preset(Control.PRESET_FULL_RECT)
    stats_container.add_theme_constant_override("separation", 10)
    stats_container.position = Vector2(15, 15)
    
    # Health bar with icon
    var health_bar = ProgressBar.new()
    health_bar.name = "HealthBar"
    health_bar.custom_minimum_size = Vector2(220, 30)
    health_bar.max_value = 100
    health_bar.value = 100
    health_bar.add_theme_color_override("font_color", Color(1, 0.3, 0.3))
    
    # Mana bar with icon
    var mana_bar = ProgressBar.new()
    mana_bar.name = "ManaBar"
    mana_bar.custom_minimum_size = Vector2(220, 30)
    mana_bar.max_value = 100
    mana_bar.value = 100
    mana_bar.add_theme_color_override("font_color", Color(0.3, 0.3, 1))
    
    stats_container.add_child(health_bar)
    stats_container.add_child(mana_bar)
    stats_panel.add_child(stats_container)
    add_child(stats_panel)