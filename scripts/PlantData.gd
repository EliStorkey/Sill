class_name PlantData
extends Resource

enum LightLevel { SHADE, INDIRECT, DIRECT }
enum MoistureLevel { DRY, MODERATE, WET }

@export var plant_name: String
@export var preferred_light: LightLevel
@export var preferred_moisture: MoistureLevel
@export var is_pet_friendly: bool
@export var sprite: Texture2D
