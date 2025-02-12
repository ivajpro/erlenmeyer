extends CharacterBody2D

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