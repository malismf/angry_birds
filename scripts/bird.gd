extends RigidBody2D
class_name Bird

signal launched

var is_launched: bool = false

func _ready() -> void:
	freeze = true

func launch(impulse: Vector2) -> void:
	if is_launched:
		return

	if impulse.is_zero_approx():
		return

	is_launched = true

	freeze = false
	sleeping = false

	apply_central_impulse(impulse)

	launched.emit()
