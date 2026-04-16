extends Node2D

# le niveau actuel
var curent_level = 1

@onready var hud = $player/HUD
@onready var player = $player
# initier la variable curent_scene_level
@onready var curent_scene_level

# La fonction qui ce fait une foi au debut du jeu
func _ready() -> void:
	# mettre le niveau (curent_level) 
	_changeLevel(curent_level)
	# conecter les signaux de player au fonction
	player.connect("utilise_potion", _utilise_potion)
	player.connect("mort", _mort)

# Fonction qui c'exécute a chaques frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass


func connect_objet():
	# commecter les porte a la fonction _changeLevel
	for porte in curent_scene_level.contenu["portes_sortie"].values():
		if not porte.is_connected("player_entred", _changeLevel):
			porte.connect("player_entred", _changeLevel)
	# commecter les ver a la fonction _ramasser_potion
	for ver in curent_scene_level.contenu["potions"].values():
		if not ver.is_connected("ramasser_potion", _ramasser_potion):
			ver.connect("ramasser_potion", _ramasser_potion)
	# commecter les pic a la fonction _prendre_degat
	for pic in curent_scene_level.contenu["pic"].values():
		if not pic.is_connected("prendre_degat", _prendre_degat):
			pic.connect("prendre_degat", _prendre_degat)
	# commecter les chest a la fonction _oppen_chest
	for chest in curent_scene_level.contenu["chest"].values():
		if not chest.is_connected("oppen_chest", _oppen_chest):
			chest.connect("oppen_chest", _oppen_chest)
	# commecter les epe a la fonction _ramasser_epe
	for epe in curent_scene_level.contenu["epe"].values():
		if not epe.is_connected("ramasser_epe", _ramasser_epe):
			epe.connect("ramasser_epe", _ramasser_epe)


#la fonction pour changer de niveau
func _changeLevel(niveau_direction):
	#suprimer la scene du niveau qu'on quitte
	if curent_scene_level != null:
		remove_child(curent_scene_level)
	
	# actualiser le niveau actuel
	curent_level = niveau_direction
	# chercher le niveau demander
	var scene = load("res://scènes/niveau" + str(curent_level) + ".tscn")
	# l'instansier
	var instance = scene.instantiate()
	# l'ajouter comme node enfant
	add_child(instance)
	# on met la scene actuel pour que au prochain changement de niveau on ne supprime pas la nle niveau 1
	curent_scene_level = instance
	connect_objet()
	# on tp le joueur au debut du niveau
	player.global_position = player.START_POSITION
	

func _ramasser_potion(id_potion, nombre):
	# supprime la potion du dictionaire contenu du niveau 
	curent_scene_level.contenu["potions"].erase(id_potion)
	player.nombre_potion += nombre
	# met a jour le nombre afficher dans l'hud
	hud.update_potion(player.nombre_potion)

func _prendre_degat(nombre):
	# met a jour les vies du joueur
	player.prendre_dega(nombre)
	# met a jour le nombre de coeur dans l'hud
	hud.update_coeur(player.vie)
	# tp le joueur au debut du niveau
	player.global_position = player.START_POSITION
	
# comme la fonction vien directement de joueur il met lui meme a jour ces vies
func _utilise_potion():
	# met a jour le nombre de coeur dans l'hud
	hud.update_coeur(player.vie)
	# met a jour le nombre afficher dans l'hud
	hud.update_potion(player.nombre_potion)

func _mort():
	# met a jour le nombre de coeur dans l'hud à 0
	# pour que l'animation d'appartition des coeur ce fait sur tous les coeur
	hud.update_coeur(0)
	hud.update_coeur(player.vie)
	# met a jour le nombre afficher dans l'hud
	hud.update_potion(player.nombre_potion)
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

func _ramasser_epe(id_epe):
	# supprime l'epe du contenu du niveau
	curent_scene_level.contenu["epe"].erase(id_epe)
	# augmante le niveau du joueur selon le niveau il pourra attaquer, dash etc
	player.niveua_amelioration += 1
