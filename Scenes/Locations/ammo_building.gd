extends Location

var time_per_ammo : float = 5
var timer : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer = time_per_ammo

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if stockpile[0] > 0 or stockpile[1] > 0:
		timer -= delta
		
		if timer <= 0:
			timer = time_per_ammo
			if stockpile[0] > 0:
				stockpile[0] -= 1
				stockpile[2] += 1
			if stockpile[1] > 0:
				stockpile[1] -= 1
				stockpile[3] += 1
