extends CharacterBody2D


@onready var animacao = $Animacao
@onready var death_timer = $DeathTimer

const SPEED:int = 65
const JUMP_VELOCITY:int = -250

var morreu = false

func _physics_process(delta: float) -> void:
	if morreu:
		return  # Impede movimentação após morte

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


func morrer():
	if morreu:
		return

	morreu = true
	velocity = Vector2.ZERO
	animacao.play("Death")
	death_timer.start()


#func _on_death_timer_timeout():
	# Aqui você pode carregar a cena do menu de retry
	# Por enquanto, um print como placeholder
	#get_tree().change_scene_to_file("res://RetryMenu.tscn")  # Troque pelo caminho correto
