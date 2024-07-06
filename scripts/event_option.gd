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

func set_image(path):
	image.texture = load(path)


func _on_button_pressed():
	selected.emit()
