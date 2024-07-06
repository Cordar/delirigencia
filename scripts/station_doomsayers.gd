extends Control

var texture = load("res://assets/images/doomsayer.png")


var button
var progress_bar
var timer
var cost_label
var anim_player

signal upgrade_failed
signal upgrade_succeeded(cost)


# Called when the node enters the scene tree for the first time.
func _ready():
	button = get_node("Button")
	progress_bar = get_node("ProgressBar")
	timer = get_node("Timer")
	cost_label = get_node("Cost")
	anim_player = get_node("AnimationPlayer")
	set_labels()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	progress_bar.value = timer.time_left / timer.wait_time * 100

func set_labels():
	cost_label.set_text("%s €" % get_upgrade_doomsayers_cost())

func hide_labels():
	cost_label.visible = false

func show_labels():
	cost_label.visible = true

func get_upgrade_doomsayers_cost():
	return (Globals.station_doomsayers_level + 1) * 100

func upgrade_doomsayers():
	var cost = get_upgrade_doomsayers_cost()
	var wait_time = 5 * (Globals.station_doomsayers_level + 1)
	if Globals.money < cost:
		Globals.play_error_sound()
	else:
		Globals.play_tap_sound()
		anim_player.play("idle")
		button.set_disabled(true)
		progress_bar.visible = true
		hide_labels()
		timer.wait_time = wait_time
		timer.start()
		await timer.timeout
		anim_player.stop()
		progress_bar.visible = false
		button.set_disabled(false)
		Globals.station_doomsayers_level += 1
		show_labels()
		set_labels()
		if Globals.station_doomsayers_level == 1:
			button.set_texture_normal(texture)

func _on_button_pressed():
	upgrade_doomsayers()
