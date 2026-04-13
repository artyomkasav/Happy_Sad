extends Node2D

var faces = []

func _ready():
	randomize()
	generate_faces()
	$Click.pressed.connect(_on_click_pressed)

func _on_click_pressed():
	generate_faces()

func generate_faces():
	faces.clear()
	var count = randi_range(1, 10)
	var screen_size = get_viewport_rect().size
	var happy_count = 0
	var sad_count = 0
	for i in range(count):
		var is_happy = randi() % 2 == 0
		var face_data = {
			"pos": Vector2(
				randf_range(120, screen_size.x - 120),
				randf_range(150, screen_size.y - 120)
			),
			"size": randf_range(20, 150),
			"eyes": randi_range(2, 6),
			"color": Color.from_hsv(randf(), 0.7, 0.9),
			"happy": is_happy }
		if is_happy:
			happy_count += 1
		else:
			sad_count += 1
		faces.append(face_data)
	$Happy.text = "Happy: " + str(happy_count)
	$Sad.text = "Sad: " + str(sad_count)
	queue_redraw()

func _draw():
	for f in faces:
		draw_single_face(f.pos, f.eyes, f.size, f.color, f.happy)

func draw_single_face(pos, eyes, size, color, happy):
	var thickness = max(2.0, size * 0.05)
	draw_arc(pos, size, 0, TAU, 64, color, thickness, true)
	var eye_y = pos.y - size * 0.3
	var total_width = size * 1.2
	var spacing = 0.0
	if eyes > 1:
		spacing = total_width / float(eyes - 1)
	var eye_radius = size * 0.12
	for i in range(eyes):
		var eye_x = pos.x - total_width / 2 + i * spacing
		var eye_pos = Vector2(eye_x, eye_y)
		draw_arc(eye_pos, eye_radius, 0, TAU, 32, color, thickness * 0.6, true)
	var left = Vector2(pos.x - size * 0.4, pos.y + size * 0.35)
	var right = Vector2(pos.x + size * 0.4, pos.y + size * 0.35)
	if happy:
		var middle = Vector2(pos.x, pos.y + size * 0.55)
		draw_polyline(PackedVector2Array([left, middle, right]), color, thickness)
	else:
		var middle = Vector2(pos.x, pos.y + size * 0.15)
		draw_polyline(PackedVector2Array([left, middle, right]), color, thickness)
