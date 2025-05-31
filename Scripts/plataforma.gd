extends StaticBody2D

@export var altura: float = 222.0
@export var velocidade: float = 50.0
@export var tempo_de_espera: float = 1.0

var direcao: int = -1
var pos_inicial: Vector2
var pode_mover: bool = true

@onready var delay_timer: Timer = $DelayTimer

func _ready():
	pos_inicial = global_position
	delay_timer.wait_time = tempo_de_espera
	delay_timer.timeout.connect(_on_delay_timeout)

func _process(delta):
	if not pode_mover:
		return

	var nova_y = global_position.y + (velocidade * direcao * delta)

	if direcao == -1 and nova_y <= pos_inicial.y - altura:
		nova_y = pos_inicial.y - altura
		pausar_e_inverter()
	elif direcao == 1 and nova_y >= pos_inicial.y:
		nova_y = pos_inicial.y
		pausar_e_inverter()

	global_position.y = nova_y

func pausar_e_inverter():
	pode_mover = false
	delay_timer.start()

func _on_delay_timeout():
	direcao *= -1
	pode_mover = true
