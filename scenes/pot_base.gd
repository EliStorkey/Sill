extends Node2D

@onready var plant_sprite: Sprite2D = $PlantSprite
var plant_data: PlantData = null

func setup(data: PlantData) -> void:
	plant_data = data
	if is_node_ready():
		_update_visuals()

func _ready() -> void:
	_update_visuals()

func _update_visuals() -> void:
	if plant_data and plant_data.sprite:
		plant_sprite.texture = plant_data.sprite
		plant_sprite.show()
	else:
		plant_sprite.texture = null
		plant_sprite.hide()
