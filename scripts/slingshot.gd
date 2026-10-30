extends Node2D

@export var max_tension: float = 150.0
@export var impulse_force: float = 10.0

@onready var bird: Bird = $Bird

var is_dragging: bool = false
var has_shot: bool = false
var slingshot_center: Vector2


func _ready() -> void:
	slingshot_center = global_position
	reset_bird()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if not has_shot and slingshot_center.distance_to(get_global_mouse_position()) < 80.0 and bird:
				is_dragging = true
		else:
			if is_dragging:
				launch_bird()


func _process(_delta: float) -> void:
	if is_dragging and bird:
		var mouse_pos = get_global_mouse_position()
		var tension_vector = mouse_pos - slingshot_center

		if tension_vector.length() > max_tension:
			tension_vector = tension_vector.limit_length(max_tension)

		bird.global_position = slingshot_center + tension_vector


func launch_bird() -> void:
	is_dragging = false
	if not bird:
		return

	var launch_vector = slingshot_center - bird.global_position

	bird.launch(launch_vector * impulse_force)
	has_shot = bird.is_launched


func reset_bird() -> void:
	if not bird:
		return

	is_dragging = false
	has_shot = false
	bird.is_launched = false
	bird.freeze = true
	bird.linear_velocity = Vector2.ZERO
	bird.angular_velocity = 0.0
	bird.global_position = slingshot_center
