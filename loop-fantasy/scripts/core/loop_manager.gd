extends Node2D

const LOOP_PATH_POINTS = [
    Vector2(100, 100),
    Vector2(500, 100),
    Vector2(500, 400),
    Vector2(100, 400)
]

const TILE_SIZE = 64
var placed_tiles = {}  # Dictionary to store placed tiles
var current_point_index: int = 0
var hero_node: CharacterBody2D
var movement_speed: float = 100.0
var enemy_scene = preload("res://scenes/characters/enemy.tscn")
var tile_scene = preload("res://scenes/tiles/path_tile.tscn")
var spawn_timer: float = 0
const SPAWN_INTERVAL: float = 3.0

func _ready():
    draw_loop_path()
    spawn_hero()
    _create_path_tiles()

func _create_path_tiles():
    for i in range(LOOP_PATH_POINTS.size()):
        var start = LOOP_PATH_POINTS[i]
        var end = LOOP_PATH_POINTS[(i + 1) % LOOP_PATH_POINTS.size()]
        _place_tiles_between(start, end)

func _place_tiles_between(start: Vector2, end: Vector2):
    var direction = (end - start).normalized()
    var distance = start.distance_to(end)
    var current_pos = start
    
    while current_pos.distance_to(end) > TILE_SIZE:
        var tile_pos = _snap_to_grid(current_pos)
        if not placed_tiles.has(tile_pos):
            var tile = tile_scene.instantiate()
            tile.position = tile_pos
            add_child(tile)
            placed_tiles[tile_pos] = tile
        current_pos += direction * TILE_SIZE

func _snap_to_grid(pos: Vector2) -> Vector2:
    return Vector2(
        floor(pos.x / TILE_SIZE) * TILE_SIZE,
        floor(pos.y / TILE_SIZE) * TILE_SIZE
    )

func _process(delta):
    if hero_node:
        move_hero()
        handle_enemy_spawn(delta)

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
        hero_node.velocity = direction * movement_speed
        hero_node.move_and_slide()

func handle_enemy_spawn(delta: float) -> void:
    spawn_timer += delta
    if spawn_timer >= SPAWN_INTERVAL:
        spawn_timer = 0
        spawn_enemy()

func spawn_enemy() -> void:
    var enemy = enemy_scene.instantiate()
    var spawn_point = LOOP_PATH_POINTS[randi() % LOOP_PATH_POINTS.size()]
    enemy.position = spawn_point
    add_child(enemy)