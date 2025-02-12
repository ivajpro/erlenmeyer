extends Node2D

const LOOP_PATH_POINTS = [
    Vector2(100, 100),
    Vector2(500, 100),
    Vector2(500, 400),
    Vector2(100, 400)
]

var current_point_index: int = 0
var hero_node: CharacterBody2D

func _ready():
    draw_loop_path()
    spawn_hero()

func _process(_delta):
    if hero_node:
        move_hero()

func draw_loop_path():
    queue_redraw()

func _draw():
    for i in range(LOOP_PATH_POINTS.size()):
        var start = LOOP_PATH_POINTS[i]
        var end = LOOP_PATH_POINTS[(i + 1) % LOOP_PATH_POINTS.size()]
        draw_line(start, end, Color.WHITE, 2.0)

func spawn_hero():
    var hero_scene = preload("res://scenes/characters/hero.tscn")
    hero_node = hero_scene.instantiate()
    hero_node.position = LOOP_PATH_POINTS[0]
    add_child(hero_node)

func move_hero():
    var target = LOOP_PATH_POINTS[current_point_index]
    var direction = (target - hero_node.position).normalized()
    var distance = hero_node.position.distance_to(target)
    
    if distance < 5:
        current_point_index = (current_point_index + 1) % LOOP_PATH_POINTS.size()
    else:
        hero_node.velocity = direction * 100
        hero_node.move_and_slide()