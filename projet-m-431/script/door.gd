extends Area2D

@onready var sprite = $AnimatedSprite2D

var is_player_in = false
signal player_entred

# le niveau vers lequelle la porte envoi
@export var level_destination = 1
@export var is_close = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# commance la premiere animation
	if is_close:
		sprite.play("closing")
	else:
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

# quand un objet sort de la porte
func _on_body_exited(body: Node2D) -> void:
	# si l'objet est le joueur
	if body.name == "player":
		is_player_in = false
