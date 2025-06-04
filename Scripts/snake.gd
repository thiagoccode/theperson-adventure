extends CharacterBody2D

@export var velocidade: float = 70.0
@export var gravidade: float = 980.0

@onready var animacao = $AnimatedSprite2D
@onready var ataque_timer = $AtaqueTimer
@onready var attack_area = $AttackArea
@onready var vulnerable_area = $VulnerableArea

var atacando: bool = false
var alvo_para_matar: Node = null
var morto: bool = false

var jogador_detectado: bool = false
var jogador_ref: Node = null

func _ready():
	$DetectArea.body_entered.connect(_on_detect_area_body_entered)
	$DetectArea.body_exited.connect(_on_detect_area_body_exited)
	attack_area.body_entered.connect(_on_attack_area_body_entered)
	vulnerable_area.body_entered.connect(_on_vulnerable_area_body_entered)
	ataque_timer.timeout.connect(_on_ataque_timer_timeout)

func _physics_process(delta: float) -> void:
	if morto:
		return  # Se já estiver morta, não faz mais nada

	if not is_on_floor():
		velocity.y += gravidade * delta
	else:
		velocity.y = 0

	if atacando:
		velocity.x = 0
	else:
		if jogador_detectado and jogador_ref:
			var direcao = (jogador_ref.global_position - global_position).normalized()
			velocity.x = direcao.x * velocidade
			animacao.flip_h = direcao.x > 0
			if animacao.animation != "Run":
				animacao.play("Run")
		else:
			velocity.x = 0
			if animacao.animation != "Idle":
				animacao.play("Idle")

	move_and_slide()

func _on_detect_area_body_entered(body: Node) -> void:
	if body.name == "Theperson":
		jogador_detectado = true
		jogador_ref = body

func _on_detect_area_body_exited(body: Node) -> void:
	if body == jogador_ref:
		jogador_detectado = false
		jogador_ref = null

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.name == "Theperson" and not atacando and is_on_floor():
		atacando = true
		alvo_para_matar = body
		velocity = Vector2.ZERO
		animacao.play("Attack")
		ataque_timer.start()

func _on_ataque_timer_timeout() -> void:
	if alvo_para_matar and attack_area.get_overlapping_bodies().has(alvo_para_matar):
		if alvo_para_matar.has_method("morrer"):
			alvo_para_matar.morrer()

	atacando = false
	alvo_para_matar = null

func _on_vulnerable_area_body_entered(body: Node2D) -> void:
	if body.name == "Theperson" and not morto:
		morrer()

func morrer() -> void:
	morto = true
	animacao.play("Dead")
	set_collision_layer(0)
	set_collision_mask(0)
	attack_area.monitoring = false
	vulnerable_area.monitoring = false
	$CollisionShape2D.disabled = true
