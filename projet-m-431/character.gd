extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const SLIDE_SPEED = 600.0
const SLIDE_DURATION = 0.4

@onready var sprite = $AnimatedSprite2D

var is_sliding = false
var slide_direction = 0
var slide_timer = 0.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_sliding:
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("move_left", "move_right")

	if Input.is_action_just_pressed("slide") and is_on_floor() and direction != 0 and not is_sliding:
		is_sliding = true
		slide_direction = direction
		slide_timer = SLIDE_DURATION
		sprite.flip_h = slide_direction < 0

	if is_sliding:
		slide_timer -= delta
		if slide_timer <= 0:
			is_sliding = false

	if is_sliding:
		velocity.x = slide_direction * SLIDE_SPEED
	else:
		if direction != 0:
			velocity.x = direction * SPEED
			sprite.flip_h = direction < 0
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	if is_sliding:
		if sprite.animation != "slide":
			sprite.play("slide")
		return

	if not is_on_floor():
		if sprite.animation != "jump":
			sprite.play("jump")
		return

	if direction != 0:
		if sprite.animation != "walk":
			sprite.play("walk")
	else:
		if sprite.animation != "idle":
			sprite.play("idle")
