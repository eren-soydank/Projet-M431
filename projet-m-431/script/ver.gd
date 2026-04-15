extends Area2D

@export var id_ver = 0
@export var nombre = 1

@onready var image = $AnimatedSprite2D
signal ramasser_potion

# Called when the node eSnters the scene tree for the first time.
func _ready() -> void:
	image.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		emit_signal("ramasser_potion", id_ver, nombre)
		queue_free()
