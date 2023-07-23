extends CharacterBody3D

signal collectable_picked_up
signal key_picked_up

var WALK_SPEED = 3.25
var SENSITIVITY = 0.002

var collectable_count = 0
var key_count = 0

@export var walking_sounds : Array[AudioStreamWAV];
var current_track = 0

@onready var head = $Head
@onready var camera = $Head/Camera3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	velocity.x = direction.x * WALK_SPEED
	velocity.z = direction.z * WALK_SPEED
	if velocity.length() > 0 and not $AudioStreamPlayer.playing:
		current_track = 0
		$AudioStreamPlayer.stream = walking_sounds[current_track]
		$AudioStreamPlayer.play()
	elif velocity.length() == 0 and $AudioStreamPlayer.playing:
		current_track = 0
		$AudioStreamPlayer.stop()
		
	move_and_slide()
	
	handle_collisions()
	
	if Input.is_action_just_pressed("interact"):
		var space_state = get_world_3d().direct_space_state
		var origin = head.global_transform.origin;
		var end = origin + -1 * head.global_transform.basis.z * 3;
		var query = PhysicsRayQueryParameters3D.create(origin, end, pow(2, 4-1))
		query.collide_with_bodies = true
		var result = space_state.intersect_ray(query)
		if result and result.collider.has_method("open"):
			key_count = result.collider.open(key_count)
			
		
	if Input.is_action_just_pressed("ui_cancel"): 
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE

func handle_collisions():
	for index in range(get_slide_collision_count()):
		# We get one of the collisions with the player
		var collision = get_slide_collision(index)

		# If the collision is with ground
		if (collision.get_collider() == null):
			continue

		# If the collider is with a collectable
		if collision.get_collider().is_in_group("collectable"):
			var collectable = collision.get_collider()
			if collectable.collectable_type == Globals.COLLECTABLE_TYPE.KEY:
				key_count += collectable.value
				key_picked_up.emit()
			else:
				collectable_picked_up.emit()
				collectable_count += collectable.value
				
			collectable.collect()
			

func _on_audio_stream_player_finished():
	current_track += 1
	if current_track >= walking_sounds.size():
		current_track = 0
	$AudioStreamPlayer.stream = walking_sounds[current_track]
