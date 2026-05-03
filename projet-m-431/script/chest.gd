extends Area2D

# la aleur du coffre : 1) bois1, 2) bois2, 3) bronze, 4) or
@export var value = 1
# l'id dois etre le meme que dans son nom (ver1 etc) 
# et que la cle dans le dictioneaire dans du niveau
@export var id = 0
# le contenu dois corespondre au nom d'une scene qui contien un objet ex: epe, ver
@export var content = ""
@onready var sprite = $AnimatedSprite2D
# pour eviter de l'ouvrir 2 fois
var is_oppened = false
var is_player_in = false

signal oppen_chest

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# lance l'animation de sa valeur
	sprite.play("idle" + str(value))


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	# si un joueur est en colision avec lui et qu'il appui sur W
	if Input.is_action_just_pressed("interact") and is_player_in and !is_oppened:
		# lance l'animation d'ouverture de la valeur corespondante
		sprite.play("oppening" + str(value))
		is_oppened = true
		# envoi un  signal a main ver la fonction _oppen_chest
		emit_signal("oppen_chest", id, content)

# quand un obget renre en colision avec lui
func _on_body_entered(body: Node2D) -> void:
	# si c'est un joueur
	if body.name == "player":
		if not is_oppened:
			print("Press E or .")
		is_player_in = true

# quand un objet sort de la colision
func _on_body_exited(body: Node2D) -> void:
	# si c'est un joueur
	if body.name == "player":
		is_player_in = false
