extends Control

var button
var cost_label
var texture0 = load("res://assets/images/info0.png")
var texture1 = load("res://assets/images/info1.png")
var texture2 = load("res://assets/images/info2.png")
var texture3 = load("res://assets/images/info3.png")

signal upgrade_failed
signal upgrade_succeeded(cost)

func _ready():
	button = get_node("Button")
	cost_label = get_node("Cost")
	set_texture()
	set_labels_text()

func _process(delta):
	pass

func get_upgrade_cost():
	return (Globals.station_news_level + 5) * pow(2, Globals.station_news_level + 1) * 100

func _on_button_pressed():
	var cost = get_upgrade_cost()
	if Globals.money < cost:
		upgrade_failed.emit()
		Globals.play_error_sound()
		return

	upgrade_succeeded.emit(cost)
	Globals.play_tap_sound()
	Globals.station_news_level += 1
	set_labels_text()
	set_texture()

func set_texture():
	var level = Globals.station_news_level
	if level == 0:
		button.set_texture_normal(texture0)
	elif level == 3:
		button.set_texture_normal(texture1)
	elif level == 5:
		button.set_texture_normal(texture2)
	else:
		button.set_texture_normal(texture3)

func set_labels_text():
	cost_label.set_text("%s €" % get_upgrade_cost())
