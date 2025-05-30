# dynamic_room.gd
extends Node3D

# Precarga de texturas
@onready var _wall_texture = load("res://materials/pared_blanca.jpg")
@onready var _floor_texture = load("res://materials/suelo_granito.jpg")

func _ready():
	self.position = Vector3.ZERO
	build_room()
	_setup_camera()

func _setup_camera():
	var camera_orbit = get_parent().find_child("CameraOrbit")
	if camera_orbit:
		var room_size = max(MedidasSingleton.anchura, MedidasSingleton.profundidad)
		camera_orbit.init_orbit(room_size)

func build_room():
	# Crear materiales con las texturas
	var wall_material = StandardMaterial3D.new()
	wall_material.albedo_texture = _wall_texture
	
	var floor_material = StandardMaterial3D.new()
	floor_material.albedo_texture = _floor_texture
	
	# Limpiar habitación existente
	for child in get_children():
		if child != self:  # Evita eliminar el propio nodo
			child.queue_free()
	
	# Obtener medidas
	var width = MedidasSingleton.anchura
	var height = MedidasSingleton.altura
	var depth = MedidasSingleton.profundidad
	
	# Crear piso (ahora con BoxMesh para mejor visualización)
	var floor_mesh = MeshInstance3D.new()
	var floor_box = BoxMesh.new()
	floor_box.size = Vector3(width, 0.1, depth)  # Grosor de 0.1
	floor_mesh.mesh = floor_box
	floor_mesh.position.y = -0.05  # Mitad del grosor
	floor_mesh.material_override = floor_material
	floor_mesh.name = "Floor"
	add_child(floor_mesh)
	
	# Crear paredes con grosor
	_create_wall(Vector3(0, height/2, -depth/2), Vector3(width, height, 0.1), 0, wall_material)
	_create_wall(Vector3(0, height/2, depth/2), Vector3(width, height, 0.1), 180, wall_material)
	_create_wall(Vector3(-width/2, height/2, 0), Vector3(depth, height, 0.1), 90, wall_material)
	_create_wall(Vector3(width/2, height/2, 0), Vector3(depth, height, 0.1), -90, wall_material)

# Función mejorada para crear paredes con BoxMesh
func _create_wall(wall_position: Vector3, size: Vector3, rotation_y: float, material: StandardMaterial3D):
	var wall = MeshInstance3D.new()
	var box = BoxMesh.new()
	box.size = size
	wall.mesh = box
	wall.material_override = material
	wall.position = wall_position
	wall.rotation.y = deg_to_rad(rotation_y)
	wall.name = "Wall_%s" % str(wall_position)
	
	# Añadir colisión
	var static_body = StaticBody3D.new()
	var collision = CollisionShape3D.new()
	collision.shape = BoxShape3D.new()
	collision.shape.size = size
	static_body.add_child(collision)
	wall.add_child(static_body)
	
	add_child(wall)
	
	# Debug visual
	print("Pared creada: ", wall.name, " en ", wall_position, " tamaño ", size)
