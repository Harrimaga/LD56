class_name Ant extends Sprite2D

enum AntType { BASIC, FLYING, RED, REDFLYING }
enum WorkType { MINE, WOOD, BUILD, TRANSPORT }

var origin : Location
var destination : Location
var path : Array[Vector2]
var path_pointer : int
var work_type : WorkType

var inventory : Array[CarryingResource]
var inventory_max : int

var speed : float
var is_flying : bool

var lifespan : float
var age : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inventory = []
	age = lifespan
	
	destination = Location.new()
	origin = Location.new()
	
	position = Vector2(randf_range(0, 1920), randf_range(0, 1080))
	origin.position = position
	destination.position = Vector2(randf_range(0, 1920), randf_range(0, 1080))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	## Lifespan update
	age -= delta
	## TODO: Death
	
	## Find path, do work
	
	if path_pointer >= path.size():
		return
		
	position = position.move_toward(path[path_pointer], speed*delta * (1.2 if is_flying else 1))

	if (position - path[path_pointer]).length() <= 0.1:
		position = path[path_pointer]
		path_pointer += 1

func do_work(p_work_type : WorkType, p_origin : Location, p_destination : Location):
	origin = p_origin
	destination = p_destination
	work_type = p_work_type

func add_to_inventory(resource : CarryingResource) -> bool:
	if inventory.size() < inventory_max:
		inventory.append(resource)
		return true
	return false

func remove_from_inventory():
	for resource in inventory:
		destination.move_resource(resource)
		
	inventory = []
