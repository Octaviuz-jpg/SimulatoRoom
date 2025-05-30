extends Control

func _on_button_pressed() -> void:
	MedidasSingleton.altura = float($Altura.text)
	MedidasSingleton.anchura = float($anchura.text)  # Nota: mayúscula consistente
	MedidasSingleton.profundidad = float($profundidad.text)
	
	get_tree().change_scene_to_file("res://node_3d.tscn")
