# AutoScrollCamera.gd
extends CameraControllerBase

@export var top_left: Vector2
@export var bottom_right: Vector2
@export var autoscroll_speed: float = 5.0

func _process(delta: float) -> void:
	# Scroll camera at a constant rate on the x-axis
	global_position.x += autoscroll_speed * delta

	# Ensure the vessel stays within the designated frame
	if target:
		var target_pos = target.global_position
		if target_pos.x < top_left.x:
			target_pos.x = top_left.x
		elif target_pos.x > bottom_right.x:
			target_pos.x = bottom_right.x
		target.global_position = target_pos

func draw_logic() -> void:
	if draw_camera_logic:
		var frame_border = ImmediateMesh.new()
		frame_border.surface_begin(Mesh.PRIMITIVE_LINES)
		
		# Define the vertices of the frame as a rectangle
		var vertices = [
			Vector3(top_left.x, 0, top_left.y),
			Vector3(bottom_right.x, 0, top_left.y),
			Vector3(bottom_right.x, 0, bottom_right.y),
			Vector3(top_left.x, 0, bottom_right.y)
		]
		
		# Draw lines between vertices, closing the rectangle by looping back to the start
		for i in range(vertices.size()):
			frame_border.vertex(vertices[i])
			frame_border.vertex(vertices[(i + 1) % vertices.size()])  # Loop back to the first point for a closed shape
		
		frame_border.surface_end()
		add_child(frame_border)
