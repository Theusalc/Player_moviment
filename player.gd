extends CharacterBody2D

enum PlayerState { IDLE, RUN, DASH }
var state: int = PlayerState.IDLE

var speed: float = 200.0

var dash_speed: float = 600.0
var dash_duration: float = 0.2
var dash_timer: float = 0.0
var dash_cooldown: float = 1.0
var cooldown_timer: float = 0.0
var dash_direction: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	
	if cooldown_timer > 0:
		cooldown_timer -= delta

	match state:
		PlayerState.IDLE, PlayerState.RUN:
			process_movement(delta)
		PlayerState.DASH:
			process_dash(delta)
		
	move_and_slide()

func process_movement(delta: float) -> void:
	
	var input_vector: Vector2 = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	
	velocity = input_vector * speed
	
	if input_vector != Vector2.ZERO:
		state = PlayerState.RUN
	else:
		state = PlayerState.IDLE

	if Input.is_action_just_pressed("dash") and cooldown_timer <= 0:
		state = PlayerState.DASH
		dash_timer = dash_duration
		
		if input_vector != Vector2.ZERO:
			state = PlayerState.DASH
			dash_timer = dash_duration
		
			dash_direction = input_vector
			velocity = dash_direction * dash_speed
			cooldown_timer = dash_cooldown

func process_dash(delta: float) -> void:
	dash_timer -= delta
	if dash_timer <= 0:
		
		state = PlayerState.IDLE
		velocity = Vector2.ZERO
