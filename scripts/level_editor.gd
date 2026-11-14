@tool
extends Node2D

@onready var floor_layer: TileMapLayer = $FloorLayer
@onready var wall_layer: TileMapLayer = $WallLayer

var last_floor_cell_count: int = -1

func _process(_delta: float) -> void:
	if Engine.is_editor_hint() and floor_layer and wall_layer:
		var current_cells = floor_layer.get_used_cells()
		
		if current_cells.size() != last_floor_cell_count:
			generate_walls(current_cells)
			last_floor_cell_count = current_cells.size()

func generate_walls(floor_cells: Array[Vector2i]) -> void:
	wall_layer.clear()
	var wall_cells: Array[Vector2i] = []
	
	for cell in floor_cells:
		var left_neighbor = cell + Vector2i(-1, 0)
		var right_neighbor = cell + Vector2i(0, -1)
		
		var needs_left = not floor_cells.has(left_neighbor)
		var needs_right = not floor_cells.has(right_neighbor)
		
		# If this edge is exposed on either side, add it to the terrain queue
		if needs_left or needs_right:
			wall_cells.append(cell)
			
	# Terrain Set 0 (Walls), Terrain 0 (First terrain in that set)
	var terrain_set = 0 
	var terrain_id = 0  
	
	# Automatically connect all gathered walls and corners using your painted bits
	wall_layer.set_cells_terrain_connect(wall_cells, terrain_set, terrain_id, true)
