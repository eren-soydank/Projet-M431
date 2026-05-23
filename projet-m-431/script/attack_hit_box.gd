extends Area2D

const HIT_BOX_END = 0.15
@onready var sprite = $AnimatedSprite2D
@onready var hit_box = $CollisionShape2D
@export var is_pogo = false
var hase_touch = false
var attack_timer = 0.0

signal touch

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play("idle")
	hit_box.disabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	attack_timer += delta
	if attack_timer >= HIT_BOX_END:
		sprite.play("disabled")
		hit_box.disabled = true

func _on_body_entered(body: Node2D) -> void:
	if body.name.begins_with("breakable"):
		body.domage(1)
		_touch()

func _on_area_entered(area: Area2D) -> void:
	if area.name.begins_with("chest") and not area.is_oppened:
		_touch()
		area.oppen()
	elif area.name.begins_with("spike"):
		_touch()

func _touch():
	if not hase_touch:
		hase_touch = true
		emit_signal("touch", is_pogo)
