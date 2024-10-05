extends Control

@onready var ant_scenes = [preload("res://Scenes/Units/BasicAnt.tscn"), 
						   preload("res://Scenes/Units/FlyingAnt.tscn"), 
						   preload("res://Scenes/Units/RedAnt.tscn"), 
						   preload("res://Scenes/Units/RedFlyingAnt.tscn")]

var ants : Array[Ant]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ants = []

	var ant : Ant = ant_scenes[1].instantiate()
	ant.path = [Vector2(100, 100), Vector2(1820, 100), Vector2(1820, 980), Vector2(100, 980)]
	ants.append(ant)
	add_child(ant)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
