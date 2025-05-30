# Main.gd
extends Node3D

@onready var room = $DynamicRoom
@onready var camera_pivot = $CameraOrbit

func _ready():
	build_room()
	center_camera()

func build_room():
	room.build_room()
	# Ajustar zoom según tamaño de la habitación
	var max_dimension = max(
		MedidasSingleton.anchura,
		MedidasSingleton.altura,
		MedidasSingleton.profundidad
	)
	camera_pivot.current_zoom = max_dimension * 1.2
	camera_pivot.min_zoom = max_dimension * 0.5
	camera_pivot.max_zoom = max_dimension * 3.0

func center_camera():
	camera_pivot.position.y = MedidasSingleton.altura / 2
