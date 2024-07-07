extends ColorRect

var time_label
var followers_label
var money_label

# Called when the node enters the scene tree for the first time.
func _ready():
	time_label = $TimeLabel
	time_label.set_text("%s segundos" % int(Globals.game_time))
	followers_label = $FollowersLabel
	followers_label.set_text(format(Globals.followers))
	money_label = $MoneyLabel
	money_label.set_text(format(Globals.money))



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

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
