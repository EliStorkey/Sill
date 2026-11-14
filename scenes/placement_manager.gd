extends Node2D

@export var floor_layer: TileMapLayer
@export var pot_scene: PackedScene
@export var camera: Camera2D

var current_preview: Node2D = null
var is_placing: bool = false
var hovered_cell: Vector2i 
var placed_pots: Dictionary = {} 
var just_placed_here: bool = false 

func _ready() -> void:
	if floor_layer and camera:
		var rect = floor_layer.get_used_rect()
		var top_corner = floor_layer.to_global(floor_layer.map_to_local(rect.position))
		var bottom_corner = floor_layer.to_global(floor_layer.map_to_local(rect.end - Vector2i(1, 1)))
		var math_center = (top_corner + bottom_corner) / 2.0
		var visual_offset = Vector2(0, -16) 
		camera.global_position = math_center + visual_offset

func toggle_placement() -> void:
	if is_placing:
		if current_preview:
			current_preview.queue_free()
		is_placing = false
	else:
		current_preview = pot_scene.instantiate()
		current_preview.modulate = Color(1, 1, 1, 0.5) 
		add_child(current_preview)
		is_placing = true
		
	queue_redraw() 

func _process(_delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var grid_coords = floor_layer.local_to_map(mouse_pos)
	
	if hovered_cell != grid_coords:
		hovered_cell = grid_coords
		just_placed_here = false 
		queue_redraw()
		
	if is_placing and is_instance_valid(current_preview):
		var snapped_pos = floor_layer.map_to_local(grid_coords)
		current_preview.global_position = snapped_pos
		
		if floor_layer.get_cell_source_id(grid_coords) != -1 and not placed_pots.has(grid_coords):
			current_preview.modulate = Color(1.0, 1.0, 1.0, 0.75) 
		else:
			current_preview.modulate = Color(0.2, 0.2, 0.2, 0.25)

func _unhandled_input(event: InputEvent) -> void:
	var mouse_pos = get_global_mouse_position()
	var grid_coords = floor_layer.local_to_map(mouse_pos)
	
	if event.is_action_pressed("left_click") and is_placing:
		if floor_layer.get_cell_source_id(grid_coords) != -1 and not placed_pots.has(grid_coords):
			var final_pot = pot_scene.instantiate()
			final_pot.global_position = floor_layer.map_to_local(grid_coords)
			add_child(final_pot)
			
			placed_pots[grid_coords] = final_pot
			just_placed_here = true 
			queue_redraw() 
			
	elif event.is_action_pressed("right_click") and is_placing:
		if placed_pots.has(grid_coords):
			placed_pots[grid_coords].queue_free()
			placed_pots.erase(grid_coords)
			just_placed_here = false 
			queue_redraw()
		# The else statement was removed here so right-clicking empty space does nothing

func _on_button_pressed() -> void:
	toggle_placement()

func _draw() -> void:
	if not is_placing or not floor_layer:
		return
		
	var tile_size = floor_layer.tile_set.tile_size
	var w = (tile_size.x / 2.0) - 2.0 
	var h = (tile_size.y / 2.0) - 1.0 
	
	var grid_color = Color(0, 0, 0, 0.1) 
	var invalid_color = Color(1.0, 0.0, 0.0, 0.3) 
	
	for cell in floor_layer.get_used_cells():
		var is_occupied = placed_pots.has(cell)
		var should_draw = false
		var color_to_draw = grid_color
		
		if cell == hovered_cell:
			if is_occupied and not just_placed_here:
				should_draw = true
				color_to_draw = invalid_color 
			else:
				should_draw = false 
		elif not is_occupied:
			should_draw = true
			
		if not should_draw:
			continue
			
		var cell_pos = floor_layer.map_to_local(cell)
		var points = PackedVector2Array([
			cell_pos + Vector2(0, -h), 
			cell_pos + Vector2(w, 0),  
			cell_pos + Vector2(0, h),  
			cell_pos + Vector2(-w, 0)  
		])
		
		draw_polygon(points, PackedColorArray([color_to_draw]))
