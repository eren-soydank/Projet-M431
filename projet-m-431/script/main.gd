extends Node2D

const DOUBLE_JUMP_PAD_SCENE = preload("res://scènes/double_jump_pad.tscn")

# le niveau actuel
var curent_level = 4

# le joueur
@onready var player = $player
# l'hud
@onready var hud = $player/hud
# initier la variable curent_scene_level
@onready var curent_scene_level

# La fonction qui ce fait une foi au debut du jeu
func _ready() -> void:
	# cette ligne sert uniquemment a tester n'importe quelle niveau sans avoir des problèmes avec les capacitées de déplacement
	player.upgrade_level = max(curent_level - 3, 0)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# mettre le niveau (curent_level)
	_changeLevel(curent_level)
	# conecter les signaux de player au fonction
	player.connect("use_glass", _use_glass)
	player.connect("death", _death)
	player.connect("double_jump", _double_jump)

# Fonction qui c'exécute a chaques frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	# si le joueur tomb trop on lui fait prendre un degat
	if player.global_position.y >= 500:
		_take_damage(1)
		
	# si on appuis sur quit (ESC) on qui le jeu
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func connect_objet():
	# pour tous les objet du niveau
	for child in curent_scene_level.get_children():
		# commecter les porte ouvertes a la fonction _changeLevel
		if child.name.begins_with("door") and not child.is_connected("player_entred", _changeLevel) and not child.is_close:
			child.connect("player_entred", _changeLevel)
		# commecter les ver a la fonction _pick_up_glass
		elif child.name.begins_with("glass") and not child.is_connected("pick_up_glass", _pick_up_glass):
			child.connect("pick_up_glass", _pick_up_glass)
		# commecter les pic a la fonction _take_damage
		elif child.name.begins_with("spike") and not child.is_connected("take_damage", _take_damage):
			child.connect("take_damage", _take_damage)
		# commecter les chest a la fonction _oppen_chest
		elif child.name.begins_with("chest") and not child.is_connected("oppen_chest", _oppen_chest):
			child.connect("oppen_chest", _oppen_chest)

# la fonction pour changer de niveau
func _changeLevel(level_destination):
	#suprimer la scene du niveau qu'on quitte
	if curent_scene_level != null:
		remove_child(curent_scene_level)
	
	# actualiser le niveau actuel
	curent_level = level_destination
	# chercher le niveau demander
	var scene = load("res://scènes/level_" + str(curent_level) + ".tscn")
	# l'instansier
	var instance = scene.instantiate()
	# l'ajouter comme node enfant
	add_child(instance)
	# on met la scene actuel pour que au prochain changement de niveau on ne supprime pas la nle niveau 1
	curent_scene_level = instance
	connect_objet()
	# on tp le joueur au debut du niveau
	tp(player.START_POSITION)

func tp(destination):
	# teleporter le joueur
	player.global_position = destination
	# le faire regarder a droite
	player.last_direction = 1
	# lui faire finire sont slide
	player.end_slide()
	# lui faire finire sont attaque
	player.end_attack()
	# lui enlever sont elant
	player.velocity.x = 0
	player.velocity.y = 0

func _pick_up_glass(number):
	# donner une potion au joueur
	player.glass_number += number
	# met a jour le nombre afficher dans l'hud
	hud.update_glass(player.glass_number)

func _take_damage(number):
	# met a jour les vies du joueur
	player.prendre_dega(number)
	# met a jour le nombre de coeur dans l'hud
	hud.update_hearts(player.hp)
	# tp le joueur au debut du niveau
	tp(player.START_POSITION)
	
# comme la fonction vien directement de joueur il met lui meme a jour ces vies
func _use_glass():
	# met a jour le nombre de coeur dans l'hud
	hud.update_hearts(player.hp)
	# met a jour le nombre afficher dans l'hud
	hud.update_glass(player.glass_number)

func _death():
	# met a jour le nombre de coeur dans l'hud à 0
	# pour que l'animation d'appartition des coeur ce fait sur tous les coeur
	hud.update_hearts(0)
	hud.update_hearts(player.hp)
	# met a jour le nombre afficher dans l'hud
	hud.update_glass(player.glass_number)
	# charge le niveau 1 et permet de ne pas supprimer les objet en cour d'utilisation
	call_deferred("_changeLevel", 1)
	# tp le joueur a debut du niveau
	tp(player.START_POSITION)
	
func _oppen_chest(chest, objet_name):
	# chercher l'objet du cofre
	var objet = load("res://scènes/" + objet_name + ".tscn")
	# l'instansier
	var object = objet.instantiate()
	# l'ajouter comme node enfant du niveau

	curent_scene_level.add_child(object)
	# le tp au dessu du cofre
	object.position.x = chest.position.x
	object.position.y = chest.position.y - 104
	object.connect("pick_up_object", _pick_up_object)

func _pick_up_object():
	# augmante le niveau du joueur selon le niveau il pourra attaquer, dash etc
	player.upgrade_level += 1
	
func _double_jump():
	# chercher l'objet du nuage
	# l'instansier
	var double_jump_pad = DOUBLE_JUMP_PAD_SCENE.instantiate()
	# l'ajouter comme node enfant du niveau
	add_child(double_jump_pad)
	# le repositionner en fonction de la position du joueur
	double_jump_pad.global_position = Vector2(player.global_position.x + 10, player.global_position.y + 90)
