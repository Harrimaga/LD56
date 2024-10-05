extends Location

@onready var ant_scenes = [preload("res://Scenes/Units/BasicAnt.tscn"), 
						   preload("res://Scenes/Units/FlyingAnt.tscn"), 
						   preload("res://Scenes/Units/RedAnt.tscn"), 
						   preload("res://Scenes/Units/RedFlyingAnt.tscn")]

var timer : float = 3
var spawn_interval = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer -= delta
	if timer <= 0:
		var ant : Ant = ant_scenes.pick_random().instantiate()
		TaskManager.add_to_pool(ant)
		get_parent().get_parent().get_parent().add_child(ant)
		timer = spawn_interval
