extends CharacterBody2D
class_name Enemy

var stats = {
    "health": 50,
    "damage": 10,
    "experience_value": 25
}

func _ready():
    # Create visual representation
    var shape = ColorRect.new()
    shape.size = Vector2(20, 20)
    shape.position = Vector2(-10, -10)
    shape.color = Color.RED
    add_child(shape)

    # Add collision
    var collision = CollisionShape2D.new()
    var rectangle = RectangleShape2D.new()
    rectangle.size = Vector2(20, 20)
    collision.shape = rectangle
    add_child(collision)

func take_damage(amount: int) -> void:
    stats.health -= amount
    if stats.health <= 0:
        queue_free()