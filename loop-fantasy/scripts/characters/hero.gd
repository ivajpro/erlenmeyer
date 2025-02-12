extends CharacterBody2D

class_name Hero

var stats = {
    "health": 100,
    "max_health": 100,
    "level": 1,
    "experience": 0,
    "next_level": 100
}

func _ready():
    # Create a basic colored shape for the hero
    var shape = ColorRect.new()
    shape.size = Vector2(20, 20)
    shape.position = Vector2(-10, -10)  # Center the shape
    shape.color = Color.BLUE
    add_child(shape)

    # Add collision shape
    var collision = CollisionShape2D.new()
    var rectangle = RectangleShape2D.new()
    rectangle.size = Vector2(20, 20)
    collision.shape = rectangle
    add_child(collision)

func _physics_process(_delta: float) -> void:
    check_combat()
    check_tile_effects()

func check_combat() -> void:
    for i in get_slide_collision_count():
        var collision = get_slide_collision(i)
        var collider = collision.get_collider()
        
        if collider is Enemy:
            # Hero attacks enemy
            collider.take_damage(10)
            # Enemy counterattacks
            take_damage(collider.stats.damage)
            
            if collider.stats.health <= 0:
                gain_experience(collider.stats.experience_value)

func check_tile_effects():
    var tiles = get_tree().get_nodes_in_group("path_tiles")
    for tile in tiles:
        if tile is PathTile:
            var distance = position.distance_to(tile.position)
            if distance < 32:  # Half tile size
                tile.apply_effects(self)

func take_damage(amount: int):
    stats.health = max(0, stats.health - amount)
    
func heal(amount: int):
    stats.health = min(stats.max_health, stats.health + amount)

func gain_experience(amount: int):
    stats.experience += amount
    if stats.experience >= stats.next_level:
        level_up()

func level_up():
    stats.level += 1
    stats.experience -= stats.next_level
    stats.next_level = stats.next_level * 1.5
    stats.max_health += 10
    stats.health = stats.max_health