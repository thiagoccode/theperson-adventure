extends Area2D

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D

var ativada: bool = false

func _ready():
	sprite.visible = false
	collision.disabled = true

func ativar_porta():
	sprite.visible = true
	collision.set_deferred("disabled", false)
	ativada = true
	print("Porta ativada!")

func _on_body_entered(body: Node) -> void:
	if ativada and body.name == "Theperson":
		print("Entrando na porta...")
		get_tree().change_scene_to_file("res://Scenes/credits.tscn")
		
		
