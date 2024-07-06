extends Node

var money = 0
var money_second_for_follower = 0.1
var followers = 0
var follower_multiplier = 1
var station_doomsayers_level = 0
var station_news_level = 0
var station_church_level = 0

var audio_stream_player
var sound_tap = load("res://assets/music/tap.wav")
var sound_error = load("res://assets/music/error.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	audio_stream_player = AudioStreamPlayer.new()
	add_child(audio_stream_player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func play_tap_sound():
	audio_stream_player.stream = sound_tap
	audio_stream_player.volume_db = 10
	play_sound()

func play_error_sound():
	audio_stream_player.stream = sound_error
	audio_stream_player.volume_db = -4
	play_sound()

func play_sound():
	audio_stream_player.play()