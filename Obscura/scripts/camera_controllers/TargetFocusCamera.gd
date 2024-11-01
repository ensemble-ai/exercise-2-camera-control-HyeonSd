# TargetFocusCamera.gd
extends CameraControllerBase

@export var lead_speed: float = 2.0
@export var catchup_delay_duration: float = 0.5
@export var catchup_speed: float = 3.0
@export var leash_distance: float = 5.0

var lead_time = 0.0

func _process(delta: float) -> void:
	if target:
		var target_pos = target.global_position
		var distance = global_position.distance_to(target_pos)

		# Leading behavior based on movement input
		if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
			lead_time += delta
			if distance < leash_distance:
				global_position = global_position.lerp(target_pos, lead_speed * delta)
		else:
			lead_time -= delta
			if lead_time <= 0:
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
