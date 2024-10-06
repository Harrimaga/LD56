extends Location

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stockpile.append(0)
	GameflowManager.universities.append(self)
	
func destination_action(ant : Ant, delta : float):
	ant.remove_from_inventory()
	TaskManager.remove_task(ant.task)
	GameflowManager.research += stockpile[4]
	stockpile[4] = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
