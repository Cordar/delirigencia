extends TextureButton

var texture1 = preload("res://assets/images/doomsayer1.png")
var texture2 = preload("res://assets/images/doomsayer2.png")
var texture3 = preload("res://assets/images/doomsayer3.png")

var image
var progress_bar
var timer
var cost_label
var anim_player
var is_building = false

signal upgrade_failed
signal upgrade_succeeded(cost)


# Called when the node enters the scene tree for the first time.
func _ready():
	image = get_node("Image")
	progress_bar = get_node("ProgressBar")
	timer = get_node("Timer")
	cost_label = get_node("Cost")
	anim_player = get_node("AnimationPlayer")
	set_labels()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	progress_bar.value = timer.time_left / timer.wait_time * 100

func set_labels():
	cost_label.set_text("%s Lc" % format(get_upgrade_doomsayers_cost()))

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
		anim_player.play("build")
		set_disabled(true)
		progress_bar.visible = true
		hide_labels()
		is_building = true
		timer.wait_time = wait_time
		timer.start()
		await timer.timeout
		is_building = false
		anim_player.play("idle")
		progress_bar.visible = false
		set_disabled(false)
		Globals.station_doomsayers_level += 1
		show_labels()
		set_labels()
		set_texture()

func _on_button_pressed():
	print("pressed")
	upgrade_doomsayers()

func set_texture():
	var lvl = Globals.station_doomsayers_level
	if lvl == 1:
		image.set_texture(texture1)
	elif lvl == 5:
		image.set_texture(texture2)
	elif lvl == 10:
		image.set_texture(texture3)


func _on_button_mouse_entered():
	if not is_building:
		Globals.play_hover_sound()
		image.set_scale(Vector2(1.02, 1.02))

func _on_button_mouse_exited():
	if not is_building:
		image.set_scale(Vector2(1.0, 1.0))
		
func format(n):
	n = str(n)
	var n_size = n.length()
	var s = ""
	
	for i in range(n_size):
		if not n[i]:
			continue
		if((n_size - i) % 3 == 0 and i > 0):
			s = str(s,",", n[i])
		else:
			s = str(s,n[i])
			
	return s
