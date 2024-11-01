# LerpSmoothCamera.gd
extends CameraControllerBase

@export var follow_speed: float = 2.0
@export var catchup_speed: float = 5.0
@export var leash_distance: float = 10.0

func _process(delta: float) -> void:
	if target:
		var target_pos = target.global_position + Vector3(0, dist_above_target, 0)
		var distance = global_position.distance_to(target_pos)

		if distance > leash_distance:
			# Smoothly follow the target
			global_position = global_position.lerp(target_pos, follow_speed * delta)
		elif distance > 0:
			# Catch up speed if closer
			global_position = global_position.lerp(target_pos, catchup_speed * delta)

func draw_logic() -> void:
	if draw_camera_logic:
		var cross_size = 5.0
		var lines = [
			Vector3(-cross_size, 0, 0), Vector3(cross_size, 0, 0),
			Vector3(0, 0, -cross_size), Vector3(0, 0, cross_size)
		]
		var mesh = ImmediateMesh.new()
		for i in range(0, lines.size(), 2):
			mesh.surface_begin(Mesh.PRIMITIVE_LINES)
			mesh.vertex(lines[i])
			mesh.vertex(lines[i + 1])
			mesh.surface_end()
		add_child(mesh)
