extends CharacterBody2D

@export var velocidade: float = 50.0
@onready var raycast_chao = $RayCast2D
@onready var raycast_parede = $RayCastParede
@onready var animacao = $AnimatedSprite2D
@onready var head_area = $HeadArea
@onready var body_area = $BodyArea

var direcao = -1
var morto = false  # ← Flag de controle de vida


func _physics_process(_delta: float) -> void:
	if morto:
		velocity = Vector2.ZERO
		return

	raycast_chao.target_position.x = 16 * direcao
	raycast_parede.target_position.x = 16 * direcao

	if not raycast_chao.is_colliding() or raycast_parede.is_colliding():
		direcao *= -1

	velocity.x = velocidade * direcao
	move_and_slide()

	animacao.flip_h = direcao < 0

	if not animacao.is_playing():
		animacao.play("Walk")

func _on_head_area_body_entered(body):
	if morto:
		return

	if body.name == "Theperson":
		morto = true
		animacao.play("Death")
		# Impede colisões que matam o player
		$BodyArea.monitoring = false
		$CollisionShape2D.disabled = true
		
		
		# Pula o jogador um pouco para cima
		body.velocity.y = -150

func _on_body_area_body_entered(body):
	if morto:
		return

	if body.name == "Theperson":
		body.morrer()  # Sua função personalizada de morte no player
