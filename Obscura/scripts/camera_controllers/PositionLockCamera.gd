# PositionLockCamera.gd
extends CameraControllerBase

func _process(_delta: float) -> void:
	# Center the camera on the vessel
	if target:
		global_position = target.global_position + Vector3(0, dist_above_target, 0)

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
