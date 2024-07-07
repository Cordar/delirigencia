extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	Globals.play_tap_sound()
	Globals.reset()
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_button_mouse_entered():
	Globals.play_hover_sound()
