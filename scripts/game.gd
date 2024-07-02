extends Control

var message_label

var followers = 0
var followers_label

var money = 0
var money_label

var money_second_for_follower = 5

var win_screen

# Called when the node enters the scene tree for the first time.
func _ready():
	followers_label = get_node("FollowersLabel")
	followers_label.text = "Followers: " + str(followers)
	money_label = get_node("MoneyLabel")
	money_label.text = "Money: " + str(money)
	message_label = get_node("MessageLabel")
	win_screen = get_node("WinScreen")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func add_follower(quantity):
	followers += quantity
	followers_label.text = "Followers: " + str(followers)

func add_money(quantity):
	money += quantity
	money_label.text = "Money: " + str(money)

func set_message(message):
	message_label.text = message
	await get_tree().create_timer(3.0).timeout
	message_label.text = ""

func win():
	get_tree().paused = true
	win_screen.visible = true

func _on_texture_button_pressed():
	add_follower(1)

func _on_update_resources_timer_timeout():
	add_money(followers * money_second_for_follower)

func _on_create_final_structure_pressed():
	if money < 100:
		set_message("Not enough money")
	else:
		win()


func _on_station_news_button_pressed():
	pass # Replace with function body.
