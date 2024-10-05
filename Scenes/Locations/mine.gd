extends Location

@onready var stockpile_label : RichTextLabel = $RichTextLabel

var capacity : int = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_task()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	stockpile_label.text = "Stock: " + str(stockpile[1])
	
func destination_action(ant : Ant, delta : float):
	ant.remove_from_inventory()
	
func origin_action(ant : Ant, delta : float) -> bool:
	while ant.add_to_inventory(CarryingResource.new(CarryingResource.ResourceType.STONE)) and stockpile[1] > 0:
		stockpile[1] -= 1
	
	if ant.inventory.size() < ant.inventory_max:
		return false
	return true

func add_task():
	TaskManager.add_task(get_resource_tile(false), self, capacity)
