# PushZoneCamera.gd
extends CameraControllerBase

@export var push_ratio: float = 0.05
@export var pushbox_top_left: Vector2
@export var pushbox_bottom_right: Vector2
@export var speedup_zone_top_left: Vector2
@export var speedup_zone_bottom_right: Vector2

func _process(delta: float) -> void:
	if target:
		var target_pos = target.global_position

		# Push vessel towards the center if it exits the pushbox
		if target_pos.x < pushbox_top_left.x or target_pos.x > pushbox_bottom_right.x or target_pos.z < pushbox_top_left.y or target_pos.z > pushbox_bottom_right.y:
			global_position = global_position.lerp(target_pos, push_ratio * delta)
		elif (target_pos.x > speedup_zone_top_left.x and target_pos.x < speedup_zone_bottom_right.x and target_pos.z > speedup_zone_top_left.y and target_pos.z < speedup_zone_bottom_right.y):
			# Camera does not move if target is within speedup zone
			global_position = global_position

func draw_logic() -> void:
	if draw_camera_logic:
		var frame_border = ImmediateMesh.new()
		frame_border.surface_begin(Mesh.PRIMITIVE_LINES)
		
		# Define the vertices of the frame
		var vertices = [
			Vector3(pushbox_top_left.x, 0, pushbox_top_left.y),
			Vector3(pushbox_bottom_right.x, 0, pushbox_top_left.y),
			Vector3(pushbox_bottom_right.x, 0, pushbox_bottom_right.y),
			Vector3(pushbox_top_left.x, 0, pushbox_bottom_right.y)
		]
		
		# Draw lines between vertices, looping back to start
		for i in range(vertices.size()):
			frame_border.vertex(vertices[i])
			frame_border.vertex(vertices[(i + 1) % vertices.size()])
		
		frame_border.surface_end()
		add_child(frame_border)
