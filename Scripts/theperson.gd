extends CharacterBody2D
# No script do jogador (ready):
	 
@onready var animacao = $Animacao

const SPEED:int = 65
const JUMP_VELOCITY:int = -250



func _physics_process(delta: float) -> void:
	# Aplica gravidade
	if not is_on_floor():
		velocity.y += get_gravity().y * delta

	# Pulo
	if (Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_up")) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Movimento lateral
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Movimento do personagem
	move_and_slide()

	# Animações
	if not is_on_floor():
		animacao.play("Jump")
	elif velocity.x != 0:
		animacao.play("Run")
	else:
		animacao.play("Idle")

	# Virar sprite
	if Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A):
		animacao.flip_h = true
	elif Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D):
		animacao.flip_h = false
