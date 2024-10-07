extends Ant

func _ready() -> void:
	inventory_max = 3
	speed = 200
	is_flying = false
	lifespan = 250
	super._ready()
	
func _process(delta: float) -> void:
	if !is_flying and age <= lifespan / 2:
		is_flying = true
		
	super._process(delta)
