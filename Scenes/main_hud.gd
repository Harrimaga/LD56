extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Health.text = "Health: " + str(GameflowManager.health)
	$Ants.text = "Ants idle: " + str(TaskManager.worker_pool.size()) 
	$Ants2.text = "Ants total: " + str(TaskManager.get_ant_count()) 
	$Score.text = "Score: " + str(GameflowManager.score)
	$Jobs.text = "Jobs: " + str(TaskManager.get_task_capacity())
