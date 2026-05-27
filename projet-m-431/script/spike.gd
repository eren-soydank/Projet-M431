extends Area2D

signal take_damage

# le nombre de degat infliger
@export var damage = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if name.begins_with("flame"):
		$AnimatedSprite2D.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass

# quand un objet entre dans la porte
func _on_body_entered(body: Node2D) -> void:
	# si l'objet est le joueur
	if body.name == "player":
		# signal a main var la fonction _take_damage
		emit_signal("take_damage", damage)
