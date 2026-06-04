extends Node2D
const MESSAGES = {
	"attaque" : "Attaque\n\n\nVous avez découvert la capacité d'attaquer avec une épée.\n\nPour l'utiliser, appuyez sur le clic gauche.\nVous pouvez frapper devant vous pour détruire les obstacles qui vous bloquent le passage.\n\nVous pouvez également cliquer en appuyant sur la flèche du bas ou sur S.\nCela permet de frapper vers le bas.\nVous pouvez aussi rebondir sur les obstacles.",

	"slide" : "Dash\n\n\nVous avez appris la capacité de dash.\n\nElle vous permet de vous élancer pour gagner de la vitesse.\n\n\nVous ne pouvez effectuer qu'un seul dash en l'air.\n\nSi vous avez commencé le dash depuis une surface, vous pouvez en effectuer un second.\n\n\nDurant le dash, vous ne perdez pas de hauteur.\nVous pouvez réutiliser votre dash après avoir rebondi sur un obstacle.",

	"wall jump" : "Wall Jump\n\n\nVous avez appris la capacité de saut mural.\n\nLorsque vous êtes contre un mur, sautez pour prendre appui dessus.\n\nVous glisser sur le mur\n\nEnchaînez plusieurs sauts muraux pour grimper le long d'une paroi.\n\n\nLe saut mural redonne le dash\nVous pouvez de nouveux dash si vous avez dash une première fois depuis un mur",

	"double jump" : "Double Jump\n\n\nVous avez appris la capacité de double saut.\n\nAprès avoir sauté une première fois, vous pouvez effectuer un second saut en l'air.\n\nCette capacité permet d'atteindre des zones plus élevées\n\nLe double saut se recharge lorsque vous touchez le sol\nvous rebondissiez sur un obstacle\nvous fait un wall jump"
}

# on recupere tous les coeur
@onready var hearts = [$heart0, $heart1, $heart2, $heart3, $heart4, $heart5, $heart6, $heart7, $heart8, $heart9]
# on recupere le ver
@onready var glass = $glass0
# on recupere le text
@onready var label = $Label0
@onready var background = $background0
@onready var timer = $timer0
@onready var tutoriel = $tutorial0
@onready var timer_tutorial = $timer_tutorial0

var time = 0.0
var hour = "00"
var minute = "00"
var second = "00"
var hundredth = "00"

signal end_tutorial

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# repositionner l'hud en fonction de la tail de l'ecrant pour garder les coeur en haut a gauche
	background.scale.x = int(max(DisplayServer.screen_get_size().x / 1920, DisplayServer.screen_get_size().y / 1080))
	background.scale.y = int(max(DisplayServer.screen_get_size().x / 1920, DisplayServer.screen_get_size().y / 1080))
	
	# on comance j'annimation du ver
	glass.play("idle")
	glass.global_position.x -= int((DisplayServer.screen_get_size().x -1920) /4)
	glass.global_position.y -= int((DisplayServer.screen_get_size().y -1080) /4)
	label.global_position.x -= int((DisplayServer.screen_get_size().x -1920) /4)
	label.global_position.y -= int((DisplayServer.screen_get_size().y -1080) /4)
	timer.global_position.x += int((DisplayServer.screen_get_size().x -1920) /4)
	timer.global_position.y -= int((DisplayServer.screen_get_size().y -1080) /4)
	# pour tous les coeur 
	for heart in hearts:
		# lance l'animation d'apparaitre
		heart.play("appear")
		heart.global_position.x -= int((DisplayServer.screen_get_size().x -1920) /4)
		heart.global_position.y -= int((DisplayServer.screen_get_size().y -1080) /4)

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	time += delta
	
	var hour = str(int(time/3600))
	if len(hour) < 2:
		hour = "0" + hour
	var minute = str(int(time/60) % 60)
	if len(minute) < 2:
		minute = "0" + minute
	var second = str(int(time) % 60)
	if len(second) < 2:
		second = "0" + second
	var hundredth = str(int(time * 100) % 100)
	if len(hundredth) < 2:
		hundredth = "0" + hundredth
	
	timer.text = "%s:%s:%s.%s" % [hour, minute, second, hundredth]
	
func update_glass(glass_number):
	# met a jour le nombre de potions afficher
	label.text = "x" + str(glass_number)

func update_hearts(number):
	# pour toutes les emplacement des coeur (le numeros du coeur - 1)
	for place in range(len(hearts)):
		# si il dois apparaitre
		if (place + 1) <= number and hearts[place].animation != "appear":
			hearts[place].play("appear")
		# si il dois disparaitre
		elif (place + 1) > number and hearts[place].animation != "disipar":
			hearts[place].play("disipar")

func appear_tutorial(name):
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.3, 0.3, 0.3, 0.5)

	style.content_margin_left = 8
	style.content_margin_right = 8
	style.content_margin_top = 4
	style.content_margin_bottom = 4

	tutoriel.add_theme_stylebox_override("normal", style)
	tutoriel.text = MESSAGES[name]
	timer_tutorial.start()

func disappear_tutorial():
	tutoriel.text = ""
	tutoriel.remove_theme_stylebox_override("normal")
	emit_signal("end_tutorial")


func _on_timer_tutorial_0_timeout() -> void:
	disappear_tutorial()
