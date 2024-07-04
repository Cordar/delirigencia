extends Control

var message_label

var followers = 0
var followers_label

var money = 0
var money_label
var money_second_label

var money_second_for_follower = 0.1

var intro_screen
var win_screen

var event_screen
var event1
var event1_title
var event1_description
var event2
var event2_title
var event2_description

var game_running = false

var update_resources_timer

# Called when the node enters the scene tree for the first time.
func _ready():
	followers_label = get_node("FollowersLabel")
	followers_label.text = "Followers: " + str(followers)
	money_label = get_node("MoneyLabel")
	money_second_label = get_node("MoneySecondLabel")
	money_label.text = "Money: " + str(money)
	message_label = get_node("MessageLabel")
	win_screen = get_node("WinScreen")
	event_screen = get_node("EventScreen")
	event1 = get_node("EventScreen/Event1")
	event1_title = get_node("EventScreen/Event1/Title")
	event1_description = get_node("EventScreen/Event1/Description")
	event2 = get_node("EventScreen/Event2")
	event2_title = get_node("EventScreen/Event2/Title")
	event2_description = get_node("EventScreen/Event2/Description")
	intro_screen = get_node("IntroScreen")
	update_resources_timer = get_node("UpdateResourcesTimer")

	set_intro()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func add_follower(quantity):
	followers += quantity
	set_follower_label(followers)

func set_follower_label(quantity):
	followers_label.text = "Followers: " + str(quantity)

func add_money(quantity):
	var old_money = money
	money += quantity
	var tween = create_tween()
	tween.tween_method(set_money_label, old_money, money, 1).set_delay(1)
	money_second_label.text = "(+" + str(snapped(quantity, 0.01)) + ")"

func set_money_label(quantity):
	var rounded_number = int(round(quantity))
	money_label.text = "Money: " + str(rounded_number)
	

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
	event_screen.visible = true
	
	event1_title.set_text("El sol es un chorizo")
	event1_description.set_text("Lanzas bots para mandar una campaña que el sol no existe y las fotos que tenemos de él son de un chorizo")
	
	event2_title.set_text("Los pájaros son drones")
	event2_description.set_text("Creas un prototipo de pájaro dron y los vas dejando por las calles para fomentar esta teoría")


func _on_event_1_pressed():
	event_screen.visible = false


func _on_event_2_pressed():
	event_screen.visible = false



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
		set_money_label(money)
		set_follower_label(followers)
		intro_screen.visible = false
		update_resources_timer.start()
		return
	
	question_label.set_text(questions[current_question].question)
	
	select_list.clear()
	for answer in questions[current_question].answers:
		select_list.add_item(answer)

func _on_initial_interview_item_clicked(index, at_position, mouse_button_index):
	current_question += 1
	money += 100
	followers += 5
	set_next_intro_question()
