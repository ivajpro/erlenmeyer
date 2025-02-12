extends CanvasLayer

var hero: Hero

func _ready():
    # Wait for scene tree to be ready
    await get_tree().process_frame
    _find_hero()

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