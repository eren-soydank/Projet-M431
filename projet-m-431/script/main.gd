extends Node2D

# le niveau actuel
var curent_level = 1

@onready var player = $player
@onready var hud = $player/hud
# initier la variable curent_scene_level
@onready var curent_scene_level

# La fonction qui ce fait une foi au debut du jeu
func _ready() -> void:
	# mettre le niveau (curent_level) 
	_changeLevel(curent_level)
	# conecter les signaux de player au fonction
	player.connect("use_glass", _use_glass)
	player.connect("death", _death)

# Fonction qui c'exécute a chaques frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass


func connect_objet():
	# commecter les porte a la fonction _changeLevel
	for door in curent_scene_level.contenu["exit_door"].values():
		if not door.is_connected("player_entred", _changeLevel):
			door.connect("player_entred", _changeLevel)
	# commecter les ver a la fonction _pick_up_glass
	for glass in curent_scene_level.contenu["glass"].values():
		if not glass.is_connected("pick_up_glass", _pick_up_glass):
			glass.connect("pick_up_glass", _pick_up_glass)
	# commecter les pic a la fonction _take_damage
	for spike in curent_scene_level.contenu["spike"].values():
		if not spike.is_connected("take_damage", _take_damage):
			spike.connect("take_damage", _take_damage)
	# commecter les chest a la fonction _oppen_chest
	for chest in curent_scene_level.contenu["chest"].values():
		if not chest.is_connected("oppen_chest", _oppen_chest):
			chest.connect("oppen_chest", _oppen_chest)
	# commecter les epe a la fonction _pick_up_sword
	for sword in curent_scene_level.contenu["sword"].values():
		if not sword.is_connected("pick_up_sword", _pick_up_sword):
			sword.connect("pick_up_sword", _pick_up_sword)


#la fonction pour changer de niveau
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
	player.global_position = player.START_POSITION
	

func _pick_up_glass(id_glass, number):
	# supprime la potion du dictionaire contenu du niveau 
	curent_scene_level.contenu["glass"].erase(id_glass)
	player.glass_number += number
	# met a jour le nombre afficher dans l'hud
	hud.update_glass(player.glass_number)

func _take_damage(number):
	# met a jour les vies du joueur
	player.prendre_dega(number)
	# met a jour le nombre de coeur dans l'hud
	hud.update_hearts(player.hp)
	# tp le joueur au debut du niveau
	player.global_position = player.START_POSITION
	
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
	player.global_position = player.START_POSITION
	
func _oppen_chest(id, objet_name):
	# chercher l'objet du cofre
	var objet = load("res://scènes/" + objet_name + ".tscn")
	# l'instansier
	var instance = objet.instantiate()
	# l'ajouter comme node enfant du niveau
	curent_scene_level.add_child(instance)
	instance.id = len(curent_scene_level.contenu[objet_name]) + 1
	# le met dans le dictionaire contenu du niveau
	curent_scene_level.contenu[objet_name][len(curent_scene_level.contenu[objet_name]) + 1] = instance
	# le tp au dessu du cofre
	instance.position.x = curent_scene_level.contenu["chest"][id].position.x
	instance.position.y = curent_scene_level.contenu["chest"][id].position.y - 104
	# met a jour tout les connection du contenu du niveau au fonction consernéa
	connect_objet()

func _pick_up_sword(id_sword):
	# supprime l'epe du contenu du niveau
	curent_scene_level.contenu["sword"].erase(id_sword)
	# augmante le niveau du joueur selon le niveau il pourra attaquer, dash etc
	player.upgrade_level += 1
