extends Control

signal picked_up

var speed = 0
var has_been_picked_up = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position.x -= speed * delta
	if self.position.x < -100:
		queue_free()


func _on_button_pressed():
	if not has_been_picked_up:
		has_been_picked_up = true
		picked_up.emit()
		queue_free()
