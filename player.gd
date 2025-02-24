extends CharacterBody2D

# Definindo os estados do jogador
enum PlayerState { IDLE, RUN, DASH }
var state: int = PlayerState.IDLE

# Variáveis de movimentação
var speed: float = 200.0

# Variáveis do dash
var dash_speed: float = 600.0
var dash_duration: float = 0.2
var dash_timer: float = 0.0
var dash_cooldown: float = 1.0
var cooldown_timer: float = 0.0
var dash_direction: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	# Atualiza o cooldown do dash
	if cooldown_timer > 0:
		cooldown_timer -= delta

	match state:
		PlayerState.IDLE, PlayerState.RUN:
			process_movement(delta)
		PlayerState.DASH:
			process_dash(delta)
	
	# Aplica o movimento usando a propriedade 'velocity'
	move_and_slide()

func process_movement(delta: float) -> void:
	# Captura os inputs para movimentação (configure em Project > Project Settings > Input Map)
	var input_vector: Vector2 = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()
	
	# Movimento básico
	velocity = input_vector * speed
	
	# Define o estado conforme o input
	if input_vector != Vector2.ZERO:
		state = PlayerState.RUN
	else:
		state = PlayerState.IDLE

	# Inicia o dash se a tecla de dash for pressionada e não estiver em cooldown
	if Input.is_action_just_pressed("dash") and cooldown_timer <= 0:
		state = PlayerState.DASH
		dash_timer = dash_duration

		# Se não houver direção, dash para a direita
		if input_vector != Vector2.ZERO:
			dash_direction = input_vector
		else:
			dash_direction = Vector2.RIGHT

		velocity = dash_direction * dash_speed
		cooldown_timer = dash_cooldown

func process_dash(delta: float) -> void:
	dash_timer -= delta
	if dash_timer <= 0:
		# Ao terminar o dash, retorna ao estado normal
		state = PlayerState.IDLE
		velocity = Vector2.ZERO
