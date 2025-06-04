extends CharacterBody2D

@onready var bounce_area: Area2D = $bounce_area
@export var velocidade: float = 40.0
@export var distancia: float = 150.0
@export var pausa: float = 3.0


var direcao: int = 1
var ponto_inicial: Vector2
var ponto_destino: Vector2
var pausando: bool = false
var jogador_em_cima: bool = false


func _ready():
	ponto_inicial = global_position
	ponto_destino = ponto_inicial + Vector2(distancia, 0)
	
	# Conecta sinais da área de detecção do jogador
	
	$Sensor.body_entered.connect(_on_sensor_body_entered)
	$Sensor.body_exited.connect(_on_sensor_body_exited)
	

func _physics_process(delta):
	if not jogador_em_cima or pausando:
		velocity.x = 0
		return

	velocity.x = direcao * velocidade
	move_and_slide()

	if direcao == 1 and global_position.x >= ponto_destino.x:
		_alternar_direcao()
	elif direcao == -1 and global_position.x <= ponto_inicial.x:
		_alternar_direcao()

func _alternar_direcao():
	pausando = true
	velocity.x = 0
	await get_tree().create_timer(pausa).timeout
	direcao *= -1
	pausando = false

func _on_sensor_body_entered(body):
	if body.name == "Theperson":
		jogador_em_cima = true

func _on_sensor_body_exited(body):
	if body.name == "Theperson":
		jogador_em_cima = false
		velocity.x = 0  # Para imediatamente
