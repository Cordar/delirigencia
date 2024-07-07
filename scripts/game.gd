extends Control

var message_label

var followers_label
var follower_second_label

var money_label
var money_second_label

var SelectEventScreen = preload("res://scenes/select_event_screen.tscn")
var PowerUp = preload("res://scenes/power_up_generator.tscn")
var intro_screen

var game_running = false

var update_resources_timer
var powerup_timer

var station_church_button
var station_church_progress_bar
var station_church_timer
var station_church_cost_label
var texture_altar0 = load("res://assets/images/altar0.png")
var texture_altar1 = load("res://assets/images/altar1.png")
var texture_altar2 = load("res://assets/images/altar2.png")
var texture_altar3 = load("res://assets/images/altar3.png")

var audio_stream_player
var caching_audio_player

func _ready():
	audio_stream_player = get_node("AudioMusic")
	caching_audio_player = $CachingAudioPlayer
	followers_label = get_node("InfoPanel/FollowersLabel")
	follower_second_label = get_node("InfoPanel/FollowersSecondLabel")
	money_label = get_node("InfoPanel/MoneyLabel")
	money_second_label = get_node("InfoPanel/MoneySecondLabel")
	message_label = get_node("MessageLabel")

	intro_screen = get_node("IntroScreen")
	update_resources_timer = get_node("UpdateResourcesTimer")
	powerup_timer = get_node("PowerupTimer")

	station_church_button = get_node("StationChurchButton")
	set_church_texture()
	station_church_progress_bar = get_node("StationChurchButton/ProgressBar")
	station_church_timer = get_node("StationChurchButton/Timer")
	station_church_cost_label = get_node("StationChurchButton/Cost")
	station_church_cost_label.set_text(str(get_upgrade_church_cost()))
	set_church_labels()
	game_running = false

	set_intro()
	
func _process(delta):
	station_church_progress_bar.value = station_church_timer.time_left / station_church_timer.wait_time * 100
	if game_running and Globals.money < 0 or Globals.followers < 1:
		lose()

	Globals.game_time += delta

func add_follower(quantity):
	var new_followers = Globals.followers + quantity
	Globals.followers = max(min(new_followers, Globals.max_followers), 0)
	set_follower_label(Globals.followers)

func set_follower_label(quantity):
	followers_label.text = "%s" % format(floor(quantity))
	var generation_second = Globals.station_doomsayers_level * Globals.follower_multiplier
	if generation_second > 0:
		follower_second_label.text = "(+%d)" % generation_second
	else:
		follower_second_label.text = "(%d)" % generation_second

func add_money(quantity):
	print(quantity)
	Globals.money += quantity
	set_money_label(Globals.money)

func add_money_gradually(quantity):
	var old_money = Globals.money
	add_money(quantity)
	var tween = create_tween()
	tween.tween_method(set_money_label, old_money, Globals.money, 1)
	money_second_label.text = "(+%d)" % quantity

func set_money_label(quantity):
	var rounded_number = int(round(quantity))
	money_label.text = "%s" % format(rounded_number)

func set_message(message):
	message_label.text = message
	await get_tree().create_timer(3.0).timeout
	message_label.text = ""

func win():
	get_tree().change_scene_to_file("res://scenes/win_screen.tscn")

func lose():
	get_tree().change_scene_to_file("res://scenes/game_over_screen.tscn")

func generate_resources(times):
	add_money(Globals.followers * Globals.money_second_for_follower * times)
	add_follower(Globals.station_doomsayers_level * Globals.follower_multiplier * times)

func _on_update_resources_timer_timeout():
	add_money_gradually(Globals.followers * Globals.money_second_for_follower)
	add_follower(Globals.station_doomsayers_level * Globals.follower_multiplier)

func set_church_texture():
	var selected_texture = texture_altar0
	if Globals.station_church_level == 1:
		selected_texture = texture_altar1
	elif Globals.station_church_level == 2:
		selected_texture = texture_altar2
	elif Globals.station_church_level == 3:
		selected_texture = texture_altar3 
	station_church_button.set_texture_normal(selected_texture)

func set_church_labels():
	station_church_cost_label.set_text("%s Lc, %s Seguidores" % [format(get_upgrade_church_cost()), format(get_upgrade_church_cost_followers())])

func upgrade_church(wait_time):
	var cost = get_upgrade_church_cost()
	var followers_required = get_upgrade_church_cost_followers()
	if Globals.money < cost:
		Globals.play_error_sound()
		set_message("No tenemos suficientes fondos.")
	elif Globals.followers < followers_required:
		Globals.play_error_sound()
		set_message("Se requieren más seguidores.")
	else:
		Globals.play_tap_sound()
		station_church_button.set_disabled(true)
		add_money(-cost)
		station_church_progress_bar.visible = true
		station_church_cost_label.visible = false
		station_church_timer.wait_time = wait_time
		station_church_timer.start()
		await station_church_timer.timeout
		station_church_progress_bar.visible = false
		station_church_button.set_disabled(false)
		Globals.station_church_level += 1
		Globals.money_second_for_follower += 0.1 * Globals.station_church_level
		station_church_cost_label.visible = true
		set_church_labels()
		set_church_texture()
		if Globals.station_church_level == 4:
			win()

func get_upgrade_church_cost():
	if Globals.station_church_level == 0:
		return 2500
	elif Globals.station_church_level == 1:
		return 100000
	elif Globals.station_church_level == 2:
		return 500000000
	elif Globals.station_church_level == 3:
		return 420691548633
	else:
		return 0

func get_upgrade_church_cost_followers():
	if Globals.station_church_level == 0:
		return 8000
	elif Globals.station_church_level == 1:
		return 80000
	elif Globals.station_church_level == 2:
		return 8000000
	elif Globals.station_church_level == 3:
		return Globals.max_followers
	else:
		return 0

func _on_create_final_structure_pressed():
	if Globals.station_church_level == 0:
		upgrade_church(5.0)
	elif Globals.station_church_level == 1:
		upgrade_church(15.0)
	elif Globals.station_church_level == 2:
		upgrade_church(30.0)
	elif Globals.station_church_level == 3:
		upgrade_church(5.0)



var current_question
var final_question
var questions = [
	{
		"question": "El juego trata de volver loco al mundo. Te apuntas?",
		"answers": ["Sí", "Claro", "Por supuesto", "No, pero como el programador no se va a poner a crear condicionales en una semana vamos a jugar igual"],
	},
	{
		"question": "Antes de empezar, unas preguntas para determinar tu carácter.",
		"answers": ["ok, boomer", "Vale!", "Uoh, que divertido!", "No quiero."],
	},
	{
		"question": "Si fueras al cine, ¿dónde te sentarías?",
		"answers": [
			"Siempre en primera fila, para que nadie me moleste.", 
			"En las filas de en medio. Entre la multitud no destacaré.",
			"En la última fila, así nadie puede verme llorar.",
			"Sentarse es de fucking panzas. Estaría de pie, delante de la pantalla. ¡Y que se queje quien quiera!"
			],
	},
	{
		"question": "Vas a una heladería. ¿Qué helado escoges?",
		"answers": [
			"Lo normal… una bola de chocolate. ¿A quién no le gusta el chocolate?",
			"¡A lo grande! Escogería dos bolas, una de pepino y otra de pistacho. O de cualquier sabor que me haga parecer interesante.",
			"El que me recomienden, seguro que me dan alguno bueno… ¿No?",
			"¿Para qué escoger? ¡Me los llevo todos! ¿Pagar?... ¿Eso qué es?"
			],
	},
	{
		"question": "Hay un gato atrapado en lo alto de un árbol. ¿Qué haces?",
		"answers": [
			"Talar el árbol, vender su madera y pedir un rescate por el gato.",
			"Gritar desesperadamente y empezar a correr en círculos.",
			"Decirle pspsps al gato. Seguro que sabe bajar solito, solo está fingiendo.",
			"Convencer al gato de que los árboles son un invento de los perros para esclavizar a los felinos."
			],
	},
	{
		"question": "Te invitan a un cumpleaños, pero no habrá comida…",
		"answers": [
			"Ir igualmente. Seguro que al final te lo pasas bien.",
			"¿Si no hay comida, por qué debería ir? La gente no me interesa, pero la comida gratis sí.",
			"Traigo táper para todos los asistentes. ¡Seguro que todos me lo agradecerán siendo amables conmigo!",
			"¡Pues monto mi propia fiesta, con mucha comida! E invitaré a las mismas personas para que no asistan al cumpleaños. ¿Qué es eso de un cumpleaños sin comida…?"
			],
	},
	{
		"question": "Estás comiendo en un restaurante y te encuentras un insecto muerto en tu plato…",
		"answers": [
			"Me lo como todo junto. ¡Más proteínas!",
			"Lo aparto con el tenedor y sigo comiendo igual. Si no toca cinco segundos el tenedor, realmente no lo ha tocado.",
			"Dejo de comer y pido que me lo cambien. Así comeré un poco más por el mismo precio. ¡Todo son ventajas!",
			"No digo nada, qué vergüenza para el cocinero… Seguro que no lo ha hecho aposta…"
			],
	},
	{
		"question": "Vas a hacer un examen y por error te lo entregan con la hoja de respuestas. ¿Qué haces?",
		"answers": [
			"Copio todas las respuestas cambiando algunas palabras para que no me pillen. ¡Por un 10 hago lo que sea!",
			"Copio algunas respuestas y otras las pienso yo. Hay que disimular…",
			"Devuelvo la hoja de respuestas antes de mirarla. ¡No sería justo para los demás!",
			"Me quedo la hoja y la revendo a los que harán el examen más tarde. Hay que tener mente de tiburón"
			],
	},
	{
		"question": "¿Por qué razón empezarías una secta?",
		"answers": [
			"Por dinero.",
			"Por fama y poder.",
			"Para crear un mundo mejor.",
			"Para llevar la contraria a alguien."
			],
	},
	{
		"question": "Consigue construir el altar al nivel máximo para ganar.",
		"answers": [
			"ok",
			"??????",
			"Eso haré!",
			"Entendido, jefe."
			],
	}
]
var select_list
var question_label

func set_intro():
	intro_screen.visible = true
	current_question = 0
	final_question = len(questions)
	question_label = get_node("IntroScreen/QuestionLabel")
	select_list = get_node("IntroScreen/InitialInterview")
	set_next_intro_question()
	
func set_next_intro_question():
	if current_question == final_question:
		set_money_label(Globals.money)
		set_follower_label(Globals.followers)
		intro_screen.visible = false
		update_resources_timer.start()
		powerup_timer.start()
		game_running = true
		return
	
	question_label.set_text(questions[current_question].question)
	
	select_list.clear()
	for answer in questions[current_question].answers:
		select_list.add_item(answer)

func give_resources_depending_on_question_answered(index):
	if current_question == 2:
		if index == 0:
			add_money(5000)
		elif index == 1:
			add_follower(10)
			add_money(1000)
		elif index == 2:
			add_money(-500)
		elif index == 3:
			add_follower(50)
	elif current_question == 3:
		if index == 0:
			add_follower(10)
			add_money(1000)
		elif index == 1:
			add_follower(50)
		elif index == 2:
			add_money(-500)
		elif index == 3:
			add_money(5000)
	elif current_question == 4:
		if index == 0:
			add_money(5000)
		elif index == 1:
			add_money(-500)
		elif index == 2:
			add_follower(10)
			add_money(1000)
		elif index == 3:
			add_follower(50)
	elif current_question == 5:
		if index == 0:
			add_follower(10)
			add_money(1000)
		elif index == 1:
			add_money(5000)
		elif index == 2:
			add_money(-500)
		elif index == 3:
			add_follower(50)
	elif current_question == 6:
		if index == 0:
			add_follower(50)
		elif index == 1:
			add_follower(10)
			add_money(1000)
		elif index == 2:
			add_money(5000)
		elif index == 3:
			add_money(-500)
	elif current_question == 7:
		if index == 0:
			add_follower(50)
		elif index == 1:
			add_follower(10)
			add_money(1000)
		elif index == 2:
			add_money(-500)
		elif index == 3:
			add_money(5000)
	elif current_question == 7:
		if index == 0:
			add_money(5000)
		elif index == 1:
			add_follower(50)
		elif index == 2:
			add_money(-500)
		elif index == 3:
			add_follower(10)
			add_money(1000)
			

func _on_initial_interview_item_clicked(index, _at_position, _mouse_button_index):
	Globals.play_tap_sound()
	give_resources_depending_on_question_answered(index)
	current_question += 1
	set_next_intro_question()

func _on_button_pressed():
	Globals.reset()
	get_tree().reload_current_scene()

func _on_button_2_pressed():
	Globals.play_error_sound()

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

func _on_station_doomsayers_upgrade_failed():
	set_message("No tenemos suficientes fondos.")

func _on_station_doomsayers_upgrade_succeeded(cost):
	add_money(-cost)


func _on_station_news_upgrade_failed():
	set_message("No tenemos suficientes fondos.")


func _on_station_news_upgrade_succeeded(cost):
	add_money(-cost)
	var select_event_screen = SelectEventScreen.instantiate()
	add_child(select_event_screen)


func _on_station_church_button_mouse_entered():
	Globals.play_hover_sound()
	station_church_button.set_scale(Vector2(1.02, 1.02))


func _on_station_church_button_mouse_exited():
	station_church_button.set_scale(Vector2(1, 1))

var power_up_times_generated = 30
func _on_powerup_picked_up():
	caching_audio_player.play()
	generate_resources(power_up_times_generated)
	if power_up_times_generated < 240:
		power_up_times_generated += 15

func _on_powerup_timer_timeout():
	var powerup = PowerUp.instantiate()
	powerup.set_position(Vector2(2000, randi() % 800 + 100))
	powerup.set_scale(Vector2(0.5, 0.5))
	powerup.speed = (randi() % 30) + 200
	powerup.picked_up.connect(_on_powerup_picked_up)
	add_child(powerup)
	powerup_timer.wait_time = max(powerup_timer.wait_time - 0.5, 2.0)
