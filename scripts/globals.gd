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
var sound_hover = load("res://assets/music/hover_sound.ogg")

func _ready():
	audio_stream_player = AudioStreamPlayer.new()
	add_child(audio_stream_player)

func play_tap_sound():
	audio_stream_player.stream = sound_tap
	audio_stream_player.volume_db = 15
	play_sound()

func play_error_sound():
	audio_stream_player.stream = sound_error
	audio_stream_player.volume_db = -5
	play_sound()

func play_hover_sound():
	audio_stream_player.stream = sound_hover
	audio_stream_player.volume_db = 10
	play_sound()

func play_sound():
	audio_stream_player.play()

func reset():
	money = 0
	money_second_for_follower = 0.1
	followers = 0
	follower_multiplier = 1
	station_doomsayers_level = 0
	station_news_level = 0
	station_church_level = 0