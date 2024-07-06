extends Control

var title
var description
var image

signal selected

# Called when the node enters the scene tree for the first time.
func _ready():
	title = get_node("Title")
	description = get_node("Description")
	image = get_node("Image")

func set_title(text):
	title.text = text

func set_description(text):
	description.text = text

func set_image(texture):
	image.texture = texture

func _on_button_pressed():
	selected.emit()

func _on_button_mouse_entered():
	Globals.play_hover_sound()
	self.set_scale(Vector2(1.01, 1.01))

func _on_button_mouse_exited():
	self.set_scale(Vector2(1, 1))
