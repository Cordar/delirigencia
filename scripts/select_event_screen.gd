extends Control


var option1
var option2
var show_effect_node
var show_effect_label
var option1_info
var option2_info
var selected_event


# Called when the node enters the scene tree for the first time.
func _ready():
	option1 = get_node("Option1")
	option2 = get_node("Option2")
	show_effect_node = get_node("ShowEffect")
	show_effect_label = get_node("ShowEffect/Label")

	show_effect_node.visible = false
	option1.visible = true
	option2.visible = true

	
	var event1_number = randi() % len(events)
	var event2_number = randi() % len(events)
	while event1_number == event2_number:
		event2_number = randi() % len(events)

	option1_info = events[event1_number]
	option2_info = events[event2_number]
	option1.set_title(option1_info.title)
	option1.set_description(option1_info.description)
	option2.set_title(option2_info.title)
	option2.set_description(option2_info.description)

func _process(_delta):
	pass

func show_effect():
	option1.visible = false
	option2.visible = false
	show_effect_label.set_text(selected_event.effect if selected_event.effect else "Falta implementar este evento")
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
		pass
	elif id == 1:
		Globals.follower_multiplier *= 50
	elif id == 2:
		pass
	elif id == 3:
		Globals.follower_multiplier *= 10
	elif id == 4:
		Globals.follower_multiplier *= 0.5
		await get_tree().create_timer(60.0).timeout
		Globals.follower_multiplier *= 2 * 20
	elif id == 5:
		pass
	elif id == 6:
		pass
	elif id == 7:
		pass
	elif id == 8:
		pass
	elif id == 9:
		pass
	elif id == 10:
		pass
	elif id == 11:
		pass
	elif id == 12:
		pass
	elif id == 13:
		pass

var events = [
	{
		id = 0,
		title = "El sol es un chorizo",
		description = "Lanzas bots para mandar una campaña que el sol no existe y las fotos que tenemos de él son de un chorizo",
		effect = ""
	},
	{
		id = 1,
		title = "Los pájaros son drones",
		description = "Creas un prototipo de pájaro dron y los vas dejando por las calles para fomentar esta teoría",
		effect = "¿Es un pájaro? Es un avión? Ah… es un… pajadron!?",
	},
	{
		id = 2,
		title = "Los gatos conquistarán el mundo",
		description = "Compartes por todas las redes sociales unas impactantes imágenes de gatos que parecen ocultar sus intenciones de dominación mundial. Al fin y al cabo, ¿a quién no le gustan las imágenes de gatitos?",
		effect = "Ahhhh!!! Nos invaden los gatoligenas!!! Quién iba a decir que eran reales??? ACABA CON ELLOS ANTES DE QUE SEA DEMASIADO MIAURDEEE."
	},
	{
		id = 3,
		title = "El 5G es un arma de control",
		description = "Compras a un prestigioso programa de televisión para que emitan una serie de cinco capítulos sobre el control gubernamental que pretenden esconder detrás de los supuestos beneficios del 5G. La globalización es una tapadera…",
		effect = "Man1: Hey, mira este serión que he visto en freeflix! habla sobre cómo un grupo de adolescentes superdotados conocen a la élite mundial y descubren la verdad, no te imaginarias lo que pasa… Si quieres te lo cuento, aunque es spoiler…

Man2:No tío mejor n…

MAN1: BUENO VALE TE LO DIGO NO HACE FALTA QUE INSISTAS RESULTA QUE EL 5G NOS CONTROLA!!! ESTAMOS PERDIDOS!!!

Man2: ._. mierda…
"
	},
	{
		id = 4,
		title = "La Tierra es plana",
		description = "Publicas un vídeo que muestra diferentes experimentos que rebaten las principales teorías sobre el universo y el planeta Tierra. ¿Cómo podríamos caminar sin caernos si la Tierra fuera esférica? No tiene ningún sentido…",
		effect = "Un hombre en su casa descubre la realidad del planeta y esa misma tarde…

Manoli: Antonio va, ve a pasear, ya sabes que el médico…

Antonio: MANOLI CÓMO VOY A IR A PASEAR??! Es que no te has enterado de la verdad??? La tierra es plana si salgo a caminar podría caerme!

Manoli: Y donde está el problema… Así te da el aire…

Antonio: *surprised Pikachu Face*
"
	},
	{
		id = 5,
		title = "Los aviones nos fumigan",
		description = "Empiezas un foro en internet en el que todo el mundo puede opinar sobre cómo se fumiga a la población a través de las nubes que dejan los aviones. Las opiniones contrarias, obviamente, son eliminadas.",
		effect = "",
	},
	{
		id = 6,
		title = "El agua deshidrata",
		description = "Escribes una columna para un periódico conocido en la que argumentas que el agua en realidad nos deshidrata. ¡Hay que beber cerveza! Y si es en el bar de tu primo, ¡mejor!",
		effect = "",
	},
	{
		id = 7,
		title = "La Luna es una proyección",
		description = "Gestionas una convención para reunir un gentío que comparta tu opinión sobre que la Luna en realidad es una proyección. Nadie ha podido llegar a ella, ¡se te acabaría la gasolina por el camino!",
		effect = "",
	},
	{
		id = 8,
		title = "Nos implantan microchips con las vacunas",
		description = "Contratas a gente para que predique con la idea de que las vacunas son un invento del gobierno para implantar microchips en el cuerpo. Seguro que nos hacen enfermar para que compremos más medicamentos.",
		effect = "",
	},
	{
		id = 9,
		title = "El cambio climático no existe",
		description = "Publicas un libro dónde desmientes el cambio climático y defiendes que la Tierra, lejos de estarse calentando, en realidad se está enfriando. Y todo para que compremos más ventiladores y crema solar…",
		effect = "",
	},
	{
		id = 10,
		title = "Los reptilianos existen, y son alienígenas",
		description = "Lanzas un pódcast con información detallada sobre las razones que demuestran la existencia de reptilianos entre la humanidad. Hay gente que no puede vivir tanto tiempo sin cambiar…",
		effect = "",
	},
	{
		id = 11,
		title = "Los móviles nos escuchan",
		description = "Compartes el “hallazgo” de un micrófono dentro de tu teléfono. Los aparatos nos escuchan, no hay otra explicación. ¿Cómo si no podrían saber siempre lo que quiero?",
		effect = "",
	},
	{
		id = 12,
		title = "Los piojos los cultivan las farmacéuticas",
		description = "Repartes un sinfín de carteles por los alrededores de las escuelas de tu ciudad, en los que expones la verdad sobre los piojos. Las empresas farmacéuticas los cultivan para vender más productos anti piojos. ¿Es que ya nadie piensa en l@s niñ@s?",
		effect = "",
	},
	{
		id = 13,
		title = "Veganismo programado",
		description = "Diriges un documental en el que revelas que los extraterrestres están tratando de convertir la población en vegana para poder debilitarnos y quedarse con los animales del planeta. Nadie se resiste a los cachorritos ni a las peluditas ovejas.",
		effect = "",
	},
]

func _on_button_2_pressed():
	Globals.play_error_sound()
