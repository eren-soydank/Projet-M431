extends Area2D
@onready var image = $AnimatedSprite2D

# boolean qui regarde si le joueur et dans la porte
var is_player_in = false
# initialiser le signal qui envoi a la fonction dans main
signal player_entred(niveau_direction)

@export var niveau_direction = 0
@export var id_porte = 0
@export var furst_animation = "idle"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match furst_animation:
		"idle":
			image.play("idle")
		"closed":
			image.play("closed")
		"closing":
			image.play("closed")
			image.play("closing")
		_:
			image.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if is_player_in and Input.is_action_just_pressed("interact"):
		# envoi un signale pour changer de niveau
		emit_signal("player_entred", niveau_direction)

# quand un objet entre dans la porte
func _on_body_entered(body: Node2D) -> void:
	# si l'objet est le joueur
	if body.name == "player":
		if furst_animation == "idle":
			print("presse W")
		is_player_in = true

# quand un objet sort de la porte
func _on_body_exited(body: Node2D) -> void:
	# si l'objet est le joueur
	if body.name == "player":
		is_player_in = false
