extends Control


var option1
var option2
var show_effect_node
var show_effect_label
var option1_info
var option2_info
var selected_event

var texture_moon = preload("res://assets/images/event_moon.png")
var texture_5g = preload("res://assets/images/event_5G.png")
var texture_vaccine = preload("res://assets/images/event_vaccine.png")
var texture_cats = preload("res://assets/images/event_cats.png")
var texture_flat_earth = preload("res://assets/images/event_flat_earth.png")
var texture_birds = preload("res://assets/images/event_birds.png")
var texture_chorizo = preload("res://assets/images/event_chorizo.png")
var texture_planes = preload("res://assets/images/event_planes.png")
var texture_water = preload("res://assets/images/event_water.png")
var texture_climatechange = preload("res://assets/images/event_climatechange.png")
var texture_micromovil = preload("res://assets/images/event_micromovil.png")
var texture_reptilianos = preload("res://assets/images/event_reptilianos.png")
var texture_piojo = preload("res://assets/images/event_piojo.png")
var texture_veganismo = preload("res://assets/images/event_veganism.png")

var positive_event = preload("res://assets/music/positive_event.wav")
var negative_event = preload("res://assets/music/negative_event.wav")
var audio_stream_player


func _ready():
	audio_stream_player = get_node("AudioStreamPlayer")
	option1 = get_node("Option1")
	option2 = get_node("Option2")
	show_effect_node = get_node("ShowEffect")
	show_effect_label = get_node("ShowEffect/Label")

	show_effect_node.visible = false
	option1.visible = true
	option2.visible = true

	if len(Globals.already_selected_events) == len(events):
		print("no more events")
		queue_free()
	else:
		var event1_number = randi() % len(events)
		while event1_number in Globals.already_selected_events:
			event1_number = randi() % len(events)
		Globals.already_selected_events.append(event1_number)
		
		var event2_number = randi() % len(events)
		while event2_number in Globals.already_selected_events:
			event2_number = randi() % len(events)
		Globals.already_selected_events.append(event2_number)

		option1_info = events[event1_number]
		option2_info = events[event2_number]
		option1.set_title(option1_info.title)
		option1.set_description(option1_info.description)
		if option1_info.image:
			option1.set_image(option1_info.image)
		option2.set_title(option2_info.title)
		option2.set_description(option2_info.description)
		if option2_info.image:
			option2.set_image(option2_info.image)

func _process(_delta):
	pass

func show_effect():
	option1.visible = false
	option2.visible = false
	show_effect_label.set_text(selected_event.effect if selected_event.effect else "Falta implementar este evento.")
	show_effect_node.visible = true

func _on_event_1_pressed():
	Globals.play_tap_sound()
	selected_event = option1_info
	show_effect()

func _on_event_2_pressed():
	Globals.play_tap_sound()
	selected_event = option2_info
	show_effect()

func _on_effect_result_button_pressed():
	Globals.play_tap_sound()
	apply_effect()
	queue_free()

func apply_effect():
	if not selected_event:
		return

	var id = selected_event.id
	if id == 0:
		audio_stream_player.stream = positive_event
		Globals.follower_multiplier *= 15
	elif id == 1:
		audio_stream_player.stream = positive_event
		Globals.follower_multiplier *= 30
	elif id == 2:
		audio_stream_player.stream = negative_event
		Globals.follower_multiplier *= -100
	elif id == 3:
		audio_stream_player.stream = positive_event
		Globals.follower_multiplier *= 10
	elif id == 4:
		audio_stream_player.stream = positive_event
		Globals.follower_multiplier *= 0.5
		await get_tree().create_timer(60.0).timeout
		Globals.follower_multiplier *= 2 * 20
	elif id == 5:
		audio_stream_player.stream = positive_event
		Globals.followers += 10000
	elif id == 6:
		audio_stream_player.stream = positive_event
		Globals.follower_multiplier *= 0.9
	elif id == 7:
		audio_stream_player.stream = positive_event
		Globals.follower_multiplier *= 3
	elif id == 8:
		audio_stream_player.stream = positive_event
		Globals.follower_multiplier *= 50
	elif id == 9:
		audio_stream_player.stream = positive_event
		Globals.follower_multiplier *= 100
	elif id == 10:
		audio_stream_player.stream = negative_event
		Globals.follower_multiplier *= 0.7
	elif id == 11:
		audio_stream_player.stream = positive_event
		Globals.follower_multiplier *= 15
	elif id == 12:
		audio_stream_player.stream = positive_event
		Globals.money += 666666666
	elif id == 13:
		audio_stream_player.stream = positive_event
		Globals.followers += 100000000
		Globals.money -= 50000000
	audio_stream_player.play()

var events = [
	{
		id = 0,
		title = "El sol es un chorizo",
		description = "Lanzas bots para mandar una campaña que el sol no existe y las fotos que tenemos de él son de un chorizo",
		image = texture_chorizo,
		effect = "La gente empieza a tener más hambre que antes y ya se sabe que con el estomago lleno no se puede pensar tan bien. Ganas seguidores más rápido."
	},
	{
		id = 1,
		title = "Los pájaros son drones",
		description = "Creas un prototipo de pájaro dron y los vas dejando por las calles para fomentar esta teoría",
		image = texture_birds,
		effect = "¿Es un pájaro? Es un avión? Ah… es un… pajadron!? Tus seguidores se unen a ti bastante más deprisa!",
	},
	{
		id = 2,
		title = "Los gatos conquistarán el mundo",
		description = "Compartes por todas las redes sociales unas impactantes imágenes de gatos que parecen ocultar sus intenciones de dominación mundial. Al fin y al cabo, ¿a quién no le gustan las imágenes de gatitos?",
		image = texture_cats,
		effect = "Ahhhh!!! Nos invaden los gatoligenas!!! Quién iba a decir que eran reales??? 
		Estás acabado, es hora de que aceptes tu destino. Tus seguidores te abandonan para ir a acariciar estas bolitas de pelo. Ahora vuelvo que creo que he visto algo de pelo por ahí..."
	},
	{
		id = 3,
		title = "El 5G es un arma de control",
		description = "Compras a un prestigioso programa de televisión para que emitan una serie de cinco capítulos sobre el control gubernamental que pretenden esconder detrás de los supuestos beneficios del 5G. La globalización es una tapadera…",
		image = texture_5g,
		effect = "Man1: Hey, mira este serión que he visto en freeflix! habla sobre cómo un grupo de adolescentes superdotados conocen a la élite mundial y descubren la verdad, no te imaginarias lo que pasa… Si quieres te lo cuento, aunque es spoiler…
Man2:No tío mejor n…
MAN1: BUENO VALE TE LO DIGO NO HACE FALTA QUE INSISTAS RESULTA QUE EL 5G NOS CONTROLA!!! ESTAMOS PERDIDOS!!!
Man2: ._. mierda…
Ganas seguidores un poco más rápido."
	},
	{
		id = 4,
		title = "La Tierra es plana",
		description = "Publicas un vídeo que muestra diferentes experimentos que rebaten las principales teorías sobre el universo y el planeta Tierra. ¿Cómo podríamos caminar sin caernos si la Tierra fuera esférica? No tiene ningún sentido…",
		image = texture_flat_earth,
		effect = "Un hombre en su casa descubre la realidad del planeta y esa misma tarde…
Manoli: Antonio va, ve a pasear, ya sabes que el médico…
Antonio: MANOLI CÓMO VOY A IR A PASEAR??! Es que no te has enterado de la verdad??? La tierra es plana si salgo a caminar podría caerme!
Manoli: Y donde está el problema… Así te da el aire…
Antonio: *surprised Pikachu Face*
Debido al miedo de salir de sus casas, te costará más ganar seguidores durante un tiempo, pero luego será mucho más fácil.
"
	},
	{
		id = 5,
		title = "Los aviones nos fumigan",
		description = "Empiezas un foro en internet en el que todo el mundo puede opinar sobre cómo se fumiga a la población a través de las nubes que dejan los aviones. Las opiniones contrarias, obviamente, son eliminadas.",
		image = texture_planes,
		effect = "La gente empieza a comprar trajes especiales para cuando llueve, los cuáles obviamente vendes tu. Ganas seguidores al instante.",
	},
	{
		id = 6,
		title = "El agua deshidrata",
		description = "Escribes una columna para un periódico conocido en la que argumentas que el agua en realidad nos deshidrata. ¡Hay que beber cerveza! Y si es en el bar de tu primo, ¡mejor!",
		image = texture_water,
		effect = "La gente es tonta, pero no tanto. Te va a costar más ganar seguidores.",
	},
	{
		id = 7,
		title = "La Luna es una proyección",
		description = "Gestionas una convención para reunir un gentío que comparta tu opinión sobre que la Luna en realidad es una proyección. Nadie ha podido llegar a ella, ¡se te acabaría la gasolina por el camino!",
		image = texture_moon,
		effect = "Lo divertido de la luna es que siempre hay alguna persona que se cree cualquier teoría al respeto. Ganas seguidores un poquitín más rápido.",
	},
	{
		id = 8,
		title = "Nos implantan microchips con las vacunas",
		description = "Contratas a gente para que predique con la idea de que las vacunas son un invento del gobierno para implantar microchips en el cuerpo. Seguro que nos hacen enfermar para que compremos más medicamentos.",
		image = texture_vaccine,
		effect = "Después de una pandemia, esta teoría no podría estar más a la moda. Ganas seguidores mucho más rápido.",
	},
	{
		id = 9,
		title = "El cambio climático no existe",
		description = "Publicas un libro dónde desmientes el cambio climático y defiendes que la Tierra, lejos de estarse calentando, en realidad se está enfriando. Y todo para que compremos más ventiladores y crema solar…",
		image = texture_climatechange,
		effect = "Es curioso como nuestro cerebro no puede pensar en negativo y sin embargo hay tanta gente que le gusta negar cosas, especialmente si están relacionadas con invertir en el futuro. Vas a ganar seguidores mucho mucho más rápido.",
	},
	{
		id = 10,
		title = "Los reptilianos existen, y son alienígenas",
		description = "Lanzas un pódcast con información detallada sobre las razones que demuestran la existencia de reptilianos entre la humanidad. Hay gente que no puede vivir tanto tiempo sin cambiar…",
		image = texture_reptilianos,
		effect = "Te has metido con las \"personas\" equivocadas. A partir de ahora te va a ser muy díficil remontar esto, te van a poner tantos palos en las ruedas que van a parecer cuadradas.",
	},
	{
		id = 11,
		title = "Los móviles nos escuchan",
		description = "Compartes el “hallazgo” de un micrófono dentro de tu teléfono. Los aparatos nos escuchan, no hay otra explicación. ¿Cómo si no podrían saber siempre lo que quiero?",
		image = texture_micromovil,
		effect = "El otro día le dije a mi madre que quería comprarme una nueva lámpara y ahora me recomiendan escape rooms de miedo MUY OSCUROS por internet.
		Claramente a todo el mundo le ha pasado y por eso te van a seguir más.",
	},
	{
		id = 12,
		title = "Los piojos los cultivan las farmacéuticas",
		description = "Repartes un sinfín de carteles por los alrededores de las escuelas de tu ciudad, en los que expones la verdad sobre los piojos. Las empresas farmacéuticas los cultivan para vender más productos anti piojos. ¿Es que ya nadie piensa en l@s niñ@s?",
		image = texture_piojo,
		effect = "Las farmacéuticas te hacen un trato para retirar los carteles. Aceptas inmediatamente, más dinero, más teorias.",
	},
	{
		id = 13,
		title = "Veganismo programado",
		description = "Diriges un documental en el que revelas que los extraterrestres están tratando de convertir la población en vegana para poder debilitarnos y quedarse con los animales del planeta. Nadie se resiste a los cachorritos ni a las peluditas ovejas.",
		image = texture_veganismo,
		effect = "Meterse con el veganismo tiene un precio. Y lo vas a pagar. También vas a ganar muchos seguidores, pero ya me dirás tu como mantienes una secta sin plata.",
	},
]

func _on_button_2_pressed():
	Globals.play_error_sound()
