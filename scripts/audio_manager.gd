extends Node

const BUS_MASTER := "Master"
const BUS_MUSIC := "Music"
const BUS_SFX := "SFX"
const BUS_AMBIENCE := "Ambience"
const BUS_UI := "UI"

var _music_player: AudioStreamPlayer
var _ambience_player: AudioStreamPlayer

func _ready() -> void:
	_music_player = AudioStreamPlayer.new()
	_music_player.bus = BUS_MUSIC
	add_child(_music_player)

	_ambience_player = AudioStreamPlayer.new()
	_ambience_player.bus = BUS_AMBIENCE
	add_child(_ambience_player)

func play_sfx(stream: AudioStream, pitch_variance: float = 0.08, volume_db: float = 0.0) -> void:
	_play_one_shot(stream, BUS_SFX, pitch_variance, volume_db)

func play_ui(stream: AudioStream, pitch_variance: float = 0.0, volume_db: float = 0.0) -> void:
	_play_one_shot(stream, BUS_UI, pitch_variance, volume_db)

func play_music(stream: AudioStream, volume_db: float = 0.0) -> void:
	if _music_player.stream == stream and _music_player.playing:
		return
	_music_player.stream = stream
	_music_player.volume_db = volume_db
	_music_player.play()

func play_ambience(stream: AudioStream, volume_db: float = 0.0) -> void:
	if _ambience_player.stream == stream and _ambience_player.playing:
		return
	_ambience_player.stream = stream
	_ambience_player.volume_db = volume_db
	_ambience_player.play()

func set_bus_volume(bus_name: String, linear_volume: float) -> void:
	var bus_idx := AudioServer.get_bus_index(bus_name)
	if bus_idx != -1:
		AudioServer.set_bus_volume_db(bus_idx, linear_to_db(clampf(linear_volume, 0.0, 1.0)))

func _play_one_shot(stream: AudioStream, bus_name: String, pitch_variance: float, volume_db: float) -> void:
	if not stream:
		return
	var player := AudioStreamPlayer.new()
	player.stream = stream
	player.bus = bus_name
	player.volume_db = volume_db
	if pitch_variance > 0.0:
		player.pitch_scale = randf_range(1.0 - pitch_variance, 1.0 + pitch_variance)
	add_child(player)
	player.finished.connect(player.queue_free)
	player.play()
