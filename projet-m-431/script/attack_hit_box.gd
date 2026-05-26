extends Area2D

# le temp dirant lequelle la hit box est active
const HIT_BOX_END = 0.1
# l'image
@onready var sprite = $AnimatedSprite2D
# la zone de colision
@onready var hit_box = $CollisionShape2D
# savoire si l'attaque et une attaque vers le bas
@export var is_pogo = false
# regarde si le pogo a dejat ete fait
var hase_touch = false
# le timer du temp de l'attaque
var attack_timer = 0.0

# le signale
signal touch

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# lancer l'animation de base
	sprite.play("idle")
	attack_timer = HIT_BOX_END

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# attaque couldown
	attack_timer -= delta
	
	# si l'attaque est fini on desactive l'image et on desactive la colision
	if attack_timer <= 0:
		sprite.play("disabled")
		hit_box.disabled = true
		# hase_touch = true ca marche aussi

func _on_body_entered(body: Node2D) -> void:
	# si l'entité qu'il a toucher et un mur cassable
	if body.name.begins_with("breakable"):
		# la fonction dans le mur pour le faire perdre un degat
		body.domage(1)
		_touch()

func _on_area_entered(area: Area2D) -> void:
		# si l'area qu'il a toucher et un coffre
	if area.name.begins_with("chest") and not area.is_oppened:
		# la fonction dans le coffre pour l'ouvrire
		area.oppen()
		_touch()
		# si l'area qu'il a toucher et un pique
	elif area.name.begins_with("spike"):
		_touch()

func _touch():
	if not hase_touch:
		hase_touch = true
		# envoi un signal a player pour pogo ou prendre le recule
		emit_signal("touch", is_pogo)
