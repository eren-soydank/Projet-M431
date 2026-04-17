extends Area2D

@onready var sprite = $AnimatedSprite2D

var is_player_in = false
signal player_entred

# l'id dois etre le meme que dans son nom (ver1 etc) 
# et que la cle dans le dictioneaire dans du niveau
@export var id = 0
# le niveau vers lequelle la porte envoi
@export var level_destination = 1
# indique si la porte est ouverte ou fermer pour avoire : "idle", "closed" ou closing
@export var furst_animation = "idle"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# commance la premiere animation
	match furst_animation:
		"idle":
			sprite.play("idle")
		"closed":
			sprite.play("closed")
		"closing":
			sprite.play("closing")
		_:
			sprite.play("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	# si le joueur est dans la porte et fait W
	if is_player_in and Input.is_action_just_pressed("interact"):
		# envoi un signale a main ver la fonction _changeLevel
		emit_signal("player_entred", level_destination)

# quand un objet entre dans la porte
func _on_body_entered(body: Node2D) -> void:
	# si l'objet est le joueur
	if body.name == "player":
		is_player_in = true
		# petit message (à supprimer)
		if furst_animation == "idle":
			print("presse W")

# quand un objet sort de la porte
func _on_body_exited(body: Node2D) -> void:
	# si l'objet est le joueur
	if body.name == "player":
		is_player_in = false
