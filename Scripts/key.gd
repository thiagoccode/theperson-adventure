extends Area2D


func _on_body_entered(body: Node) -> void:
	if body.name == "Theperson":  # substitua pelo nome do seu personagem, se for diferente
		var porta = get_node("../Door")  # Caminho relativo para a porta (irmã de Key)
		if porta:
			porta.call("ativar_porta")
		queue_free()  # Remove a chave
